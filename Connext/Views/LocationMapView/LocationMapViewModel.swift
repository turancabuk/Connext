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
    @MainActor
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
            Task {
                do{
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                }catch{
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
        func getCheckInCounts() {
            Task {
                do{
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                }catch{
                    alertItem = AlertContext.checkedInCount
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
