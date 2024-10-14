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
        @Published var isShowingDetailView  = false
        @Published var isLoadingView        = false
        let deviceLocationManager           = CLLocationManager()
        @Published var region               = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.067204,longitude: 29.014965),
                                                                 span: MKCoordinateSpan(latitudeDelta: 0.3,longitudeDelta: 0.3))
        
        
        override init () {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        @MainActor
        func getLocations(for locationManager: LocationManager) {
            showLoadingView()
            Task {
                do{
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                    hideLoadingView()
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
        @MainActor
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
            print("did fail with error")
        }
        
        func showLoadingView() { isLoadingView = true }
        func hideLoadingView() { isLoadingView = false}
    }
}
