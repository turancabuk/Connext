//
//  LocationMapViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI
import MapKit

final class LocationMapViewModel: NSObject, ObservableObject {
    
    @Published var alertItem: AlertItem?
    var deviceLocationManager: CLLocationManager?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,
                                                                                  longitude: -121.891054),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                          longitudeDelta: 0.01))
    
    func checkIfLocationServiceIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            deviceLocationManager = CLLocationManager()
            deviceLocationManager!.delegate = self
            
        }else{
            alertItem = AlertContext.locationDisabled
        }
    }
    
    func checkLocationAuthorization() {
        guard let deviceLocationManager = deviceLocationManager else {return}
        
        switch deviceLocationManager.authorizationStatus {
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertItem = AlertContext.locationRestricted
        case .denied:
            alertItem = AlertContext.locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
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
}

extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
