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
    
    final class LocationMapViewModel:  NSObject, ObservableObject, CLLocationManagerDelegate {
       
        @Published var checkedInProfiles    : [CKRecord.ID : Int] = [:]
        @Published var alertItem            : AlertItem?
        let deviceLocationManager           = CLLocationManager()
        @Published var isShowingDetailView  = false
        @Published var region               = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,longitude: -121.891054),
                                                                 span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01))
        
        
        override init () {
            super.init()
            deviceLocationManager.delegate = self
        }
        
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
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let checkedProfiles):
                        checkedInProfiles = checkedProfiles
                    case .failure(_):
                        alertItem = AlertContext.checkedInCount
                        break
                    }
                }
            }
        }
        
        func requestAllowOnceLocationPermission() {
            deviceLocationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            
            withAnimation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
            
        }
    }
}
