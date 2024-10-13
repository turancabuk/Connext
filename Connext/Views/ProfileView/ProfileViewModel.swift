//
//  ProfileViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 17.08.2024.
//

import SwiftUI
import CloudKit

enum ProfileConnext { case create, update }

extension ProfileView {
    @MainActor
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

            Task {
                do{
                    let records = try await CloudKitManager.shared.batchSave(for: [userRecord, profileRecord])
                    for record in records {
                        self.existingProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    hideLoadingView()
                    alertItem = AlertContext.profileSavingSuccesfull
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.profileSavingFailure
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

            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(id: profileRecordID)
                    self.existingProfileRecord = record
                    let profile = Profile(record: record)
                    name        = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio         = profile.bio
                    avatarImage = profile.avatarImage
                    hideLoadingView()
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
        
        func updateProfile() {
            guard checkRequirements() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            guard let existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            existingProfileRecord[Profile.kFirstName]   = name
            existingProfileRecord[Profile.kLastName]    = lastName
            existingProfileRecord[Profile.kCompanyName] = companyName
            existingProfileRecord[Profile.kBio]         = bio
            existingProfileRecord[Profile.kAvatar]      = avatarImage?.convertToCKAsset()
            
            showLoadingView()
            
            Task {
                do{
                    _ = try await CloudKitManager.shared.save(for: existingProfileRecord)
                    hideLoadingView()
                    alertItem = AlertContext.profileUpdatingSuccesfull
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.profileUpdatingFailure
                }
            }
        }
        
        func checkOut() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
                return alertItem      = AlertContext.unableToGetProfile
            }
            
            Task {
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(id: profileRecordID)
                    record[Profile.kIsCheckedIn] = nil
                    record[Profile.kIsCheckedInNilCheck] = nil
                    
                    let _ = try await CloudKitManager.shared.save(for: record)
                    isCheckedIn = false
                    hideLoadingView()
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetCheckInorOut
                }
            }
        }
        
        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else {return}
            
            Task {
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(id: profileRecordID)
                    if let _ = record[Profile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = true
                    }else{
                        isCheckedIn = false
                    }
                }catch{
                    isCheckedIn = false
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

}
