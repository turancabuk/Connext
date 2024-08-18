//
//  ProfileViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 17.08.2024.
//

import SwiftUI
import CloudKit

final class ProfileViewModel: ObservableObject {
    
    @Published var name: String         = ""
    @Published var lastName: String     = ""
    @Published var companyName: String  = ""
    @Published var bio: String          = ""
    @Published var avatarImage          : UIImage?
    @Published var alertItem            : AlertItem?
    
    func getProfile() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                let profileReference = userRecord["ConnextProfile"] as! CKRecord.Reference
                let profileRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, error in
                    guard let profileRecord = profileRecord, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        let profile = Profile(record: profileRecord)
                        name        = profile.firstName
                        lastName    = profile.lastName
                        companyName = profile.companyName
                        bio         = profile.bio
                        avatarImage = profile.createAvatarImage()
                    }
                }
            }
        }
    }
    
    func createProfile() {
        guard checkRequirements() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[Profile.kFirstName]   = name
        profileRecord[Profile.kLastName]    = lastName
        profileRecord[Profile.kCompanyName] = companyName
        profileRecord[Profile.kBio]         = bio
        profileRecord[Profile.kAvatar]      = avatarImage?.convertToCKAsset()
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                userRecord["ConnextProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
                
                operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
                    guard let savedRecords = savedRecords, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    print(savedRecords)
                }
                CKContainer.default().publicCloudDatabase.add(operation)
            }
        }
    }
    
    func checkRequirements() -> Bool {
        guard !name.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              avatarImage != nil,
              bio.count <= 100
        else {return false}
        return true
    }
}
