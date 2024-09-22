//
//  LocationDetailViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 22.08.2024.
//

import SwiftUI
import MapKit
import CloudKit

enum checkInStatus { case checkedIn, checkedOut }

class LocationDetailViewModel: ObservableObject {
    
    @Published var isShowingProfileModal = false
    var location: Location
    var checkStatus: Bool = false
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
    
    func updateCheckInStatus(checkInStatus: checkInStatus) {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        
        CloudKitManager.shared.fetchRecord(id: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                switch checkInStatus {
                case .checkedIn:
                    record[Profile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    checkStatus = true
                case .checkedOut:
                    record[Profile.kIsCheckedIn] = nil
                    checkStatus = false
                }
                
                CloudKitManager.shared.save(record: record) { result in
                    switch result {
                    case .success(_):
                        print("✅ Succes!")
                    case .failure(_):
                        print("❌ Failure!")
                    }
                }
            case .failure(let failure):
                print("❌ Saving Failure: \(failure.localizedDescription)")
            }
        }
    }
}
