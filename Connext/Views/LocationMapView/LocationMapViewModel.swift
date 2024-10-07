//
//  LocationMapViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI
import CloudKit
import MapKit

extension LocationMapView {
    
    final class LocationMapViewModel:  ObservableObject {
        @Published var checkedInProfiles    : [CKRecord.ID : Int] = [:]
        @Published var isShowingDetailView  = false
        @Published var alertItem            : AlertItem?
        @Published var region               = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,longitude: -121.891054),
                                                                 span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01))
        
        
        func getLocations(for locationManager: LocationManager) {
            CloudKitManager.getLocations { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locations):
                        locationManager.locations = locations
                    case .failure(_):
                        self.alertItem = AlertContext.unableToGetLocations
                    }
                }
            }
        }
        
        func getCheckInCounts() {
            CloudKitManager.shared.getCheckedInProfilesCount { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let checkedProfiles):
                        self.checkedInProfiles = checkedProfiles
                    case .failure(_):
                        // Show alert
                        break
                    }
                }
            }
        }
    }
}
