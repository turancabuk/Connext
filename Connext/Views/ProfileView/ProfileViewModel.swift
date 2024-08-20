//
//  ProfileViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 17.08.2024.
//

import SwiftUI
import CloudKit

enum ProfileConnext { case create, update }

final class ProfileViewModel: ObservableObject {
    
    @Published var name: String         = ""
    @Published var lastName: String     = ""
    @Published var companyName: String  = ""
    @Published var bio: String          = ""
    @Published var avatarImage          : UIImage?
    @Published var alertItem            : AlertItem?
    @Published var isLoadingView: Bool  = false
    var profileContext: ProfileConnext  = .create
    private var existingProfileRecord   : CKRecord? {
        didSet { profileContext = .update}
    }
    
    func getProfile() {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertContext.noUserRecord
            return
        }
        guard let profileReference = userRecord["ConnextProfile"] as? CKRecord.Reference else {return}
        let profileRecordID = profileReference.recordID
        
        showLoadingView()
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let record):
                    self.existingProfileRecord = record
                    let profile = Profile(record: record)
                    name        = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio         = profile.bio
                    avatarImage = profile.createAvatarImage()
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
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
        
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertContext.noUserRecord
            return
        }

        userRecord["ConnextProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async {
                self.hideLoadingView()
                
                switch result {
                case .success(let records):
                    for record in records where record.recordType == RecordType.profile {
                        self.existingProfileRecord = record
                    }
                    self.alertItem = AlertContext.profileSavingSuccesfull
                case .failure(_):
                    self.alertItem = AlertContext.profileSavingFailure
                    break
                }
            }
        }
    }
    
    func updateProfile() {
        guard checkRequirements() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        profileRecord[Profile.kFirstName]   = name
        profileRecord[Profile.kLastName]    = lastName
        profileRecord[Profile.kCompanyName] = companyName
        profileRecord[Profile.kBio]         = bio
        profileRecord[Profile.kAvatar]      = avatarImage?.convertToCKAsset()
        
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async {
                self.hideLoadingView()
                switch result {
                case .success(_):
                    self.alertItem = AlertContext.profileUpdatingSuccesfull
                case .failure(_):
                    self.alertItem = AlertContext.profileUpdatingFailure
                }
            }
        }
    }
    
    // Helper Methods.
    private func checkRequirements() -> Bool {
        guard !name.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              avatarImage != nil,
              bio.count <= 100
        else {return false}
        return true
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[Profile.kFirstName]   = name
        profileRecord[Profile.kLastName]    = lastName
        profileRecord[Profile.kCompanyName] = companyName
        profileRecord[Profile.kBio]         = bio
        profileRecord[Profile.kAvatar]      = avatarImage?.convertToCKAsset()
        return profileRecord
    }
    
    private func showLoadingView() { isLoadingView = true }
    private func hideLoadingView() { isLoadingView = false }
}
