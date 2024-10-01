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

final class LocationDetailViewModel: ObservableObject {
    
    @Published var checkedProfiles: [Profile] = []
    @Published var isCheckedIn = false
    @Published var isShowingProfileModal = false
    @Published var isLoadingView = false
    @Published var alertItem: AlertItem?
    var location: Location
    let columns = [GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100))]
    
    init(location: Location) {
        self.location = location
    }
    
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        
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
                        isCheckedIn = reference.recordID == location.id
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
            return alertItem = AlertContext.unableToGetProfile
        }
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async { [self] in
                    switch checkInStatus {
                    case .checkedIn:
                        record[Profile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    case .checkedOut:
                        record[Profile.kIsCheckedIn] = nil
                    }
                }
                
                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(let record):
                            let profile = Profile(record: record)
                            switch checkInStatus {
                            case .checkedIn:
                                self.checkedProfiles.append(profile)
                            case .checkedOut:
                                self.checkedProfiles.removeAll(where: { $0.id == profile.id })
                            }
                            
                            isCheckedIn = checkInStatus == .checkedIn

                        case .failure(_):
                            alertItem = AlertContext.profileUpdatingFailure
                        }
                    }
                }
            case .failure(let failure):
                alertItem = AlertContext.unableToGetCheckInorOut
            }
        }
    }
    
    func getCheckedProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedProfiles = profiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckInorOut
                }
                hideLoadingView()
            }
        }
    }
    
    private func showLoadingView() { self.isLoadingView = true }
    private func hideLoadingView() { self.isLoadingView = false}
}

