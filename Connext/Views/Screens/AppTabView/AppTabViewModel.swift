//
//  AppTabViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 5.10.2024.
//

import CoreLocation


final class AppTabViewModel: NSObject, ObservableObject {
    
    @Published var isShowingOnboardView : Bool = false
    @Published var alertItem            : AlertItem?
    var deviceLocationManager           : CLLocationManager?
    var hasSeenOnboardView              : Bool {return UserDefaults.standard.bool(forKey: "kHasSeenOnboardView")}
    
    func runStartUpChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: "kHasSeenOnboardView")
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
