//
//  AppTabViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 5.10.2024.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        var deviceLocationManager           : CLLocationManager?
        @Published var isShowingOnboardView : Bool = false
        @Published var alertItem            : AlertItem?
        @AppStorage("kHasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = true }
        }

        
        func runStartUpChecks() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            }else{
                checkIfLocationServiceIsEnabled()
            }
        }
        
        func checkIfLocationServiceIsEnabled() {
            DispatchQueue.main.async { [self] in
                if CLLocationManager.locationServicesEnabled() {
                    deviceLocationManager = CLLocationManager()
                    deviceLocationManager!.delegate = self
                    
                }else{
                    alertItem = AlertContext.locationDisabled
                }
            }
        }
        
        private func checkLocationAuthorization() {
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
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}
