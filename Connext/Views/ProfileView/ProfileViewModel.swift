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
    @Published var isCheckedIn          = false
    var profileContext: ProfileConnext  = .create
    private var existingProfileRecord   : CKRecord? {
        didSet { profileContext = .update}
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
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    self.alertItem = AlertContext.profileSavingSuccesfull
                case .failure(_):
                    self.alertItem = AlertContext.profileSavingFailure
                    break
                }
            }
        }
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
                    avatarImage = profile.avatarImage
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
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
    
    func checkOut() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return alertItem      = AlertContext.unableToGetProfile
        }
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                record[Profile.kIsCheckedIn] = nil
                record[Profile.kIsCheckedInNilCheck] = nil
                
                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(_):
                            isCheckedIn = false
                        case .failure(_):
                            alertItem = AlertContext.unableToGetCheckInorOut
                        }
                    }
                }
            case .failure(_):
                DispatchQueue.main.async { [self] in
                    alertItem = AlertContext.unableToGetCheckInorOut
                }
            }
        }
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {return}
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if let _ = record[Profile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = true
                    }else{
                        isCheckedIn = false
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    // Helper Methods.
    private func checkRequirements() -> Bool {
        guard !name.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              bio.count <= 100,
              avatarImage != nil
        else {return false}
        return true
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType : RecordType.profile)
        profileRecord[Profile.kFirstName]       = name
        profileRecord[Profile.kLastName]        = lastName
        profileRecord[Profile.kCompanyName]     = companyName
        profileRecord[Profile.kBio]             = bio
        profileRecord[Profile.kAvatar]          = avatarImage?.convertToCKAsset()
        return profileRecord
    }
    
    private func showLoadingView() { isLoadingView = true }
    private func hideLoadingView() { isLoadingView = false }
}
