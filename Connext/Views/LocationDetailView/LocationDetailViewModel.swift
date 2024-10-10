//
//  LocationDetailViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 22.08.2024.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

@MainActor
final class LocationDetailViewModel: ObservableObject {
    @Published var checkedProfiles          : [Profile] = []
    @Published var isCheckedIn              = false
    @Published var isShowingProfileModal    = false
    @Published var isLoadingView            = false
    @Published var alertItem                : AlertItem?
    var location                            : Location
    var selectedProfile                     : Profile?
    let columns = [GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100))]
    
    init(location: Location) {self.location = location}
    
    func getDirectionsToLocation() {
        let placeMark   = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem     = MKMapItem(placemark: placeMark)
        mapItem.name     = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else  {return}
        UIApplication.shared.open(url)
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {return}
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if let reference = record[Profile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn  = reference.recordID == location.id
                    }else{
                        isCheckedIn = false
                        print("isCheckedIn = false")
                    }
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckInStatus
                }
            }
        }
    }
    
    func updateCheckInStatus(checkInStatus: CheckInStatus) {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return alertItem          = AlertContext.unableToGetProfile
        }
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async { [self] in
                    switch checkInStatus {
                    case .checkedIn:
                        record[Profile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                        record[Profile.kIsCheckedInNilCheck] = 1
                    case .checkedOut:
                        record[Profile.kIsCheckedIn] = nil
                        record[Profile.kIsCheckedInNilCheck] = nil
                    }
                }
                
                //                CloudKitManager.shared.save(record: record) { result in
                //                    DispatchQueue.main.async { [self] in
                //                        switch result {
                //                        case .success(let record):
                //                            let profile = Profile(record: record)
                //                            switch checkInStatus {
                //                            case .checkedIn:
                //                                self.checkedProfiles.append(profile)
                //                            case .checkedOut:
                //                                self.checkedProfiles.removeAll(where: { $0.id == profile.id })
                //                            }
                //
                //                            isCheckedIn.toggle()
                //
                //                        case .failure(_):
                //                            alertItem = AlertContext.profileUpdatingFailure
                //                        }
                //                    }
                //                }
                Task {
                    let profile = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                    switch checkInStatus {
                    case .checkedIn:
                        self.checkedProfiles.append(contentsOf: profile)
                    case .checkedOut:
                        self.checkedProfiles.removeAll(where: { $0.id == profile })
                    }
                }
            case .failure(_):
                alertItem = AlertContext.unableToGetCheckInorOut
            }
        }
    }
    
    func getCheckedProfiles() {
        showLoadingView()
        
        Task {
            do{
                checkedProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                hideLoadingView()
            }catch{
                hideLoadingView()
                alertItem = AlertContext.unableToGetCheckInorOut
            }
        }
    }
    
    func show(_ profile: Profile, in sizeCategory: ContentSizeCategory) {
        selectedProfile = profile
        if sizeCategory >= .accessibilityMedium {
            isShowingProfileModal = true
        } else {
            isShowingProfileModal = true
        }
    }
    
    private func showLoadingView() {self.isLoadingView = true}
    private func hideLoadingView() {self.isLoadingView = false}
}

