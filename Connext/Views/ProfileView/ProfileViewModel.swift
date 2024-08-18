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
        
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show alert
            return
        }
        guard let profileReference = userRecord["ConnextProfile"] as? CKRecord.Reference else {
            // Show alert
            return
        }
        let profileRecordID = profileReference.recordID
        
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    let profile = Profile(record: record)
                    name        = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio         = profile.bio
                    avatarImage = profile.createAvatarImage()
                    
                case .failure(let failure):
                    // Show alert
                    break
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
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            //Show alert
            return
        }
        
        userRecord["ConnextProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
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
