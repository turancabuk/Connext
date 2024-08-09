//
//  LocationMapViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI
import MapKit

final class LocationMapViewModel: ObservableObject {
    
    @Published var locations: [Location] = []
    @Published var alertItem: AlertItem?
    @Published var region = MKCoordinateRegion(
        center:
            CLLocationCoordinate2D(
                latitude: 37.331516,
                longitude: -121.891054
            ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    func getLocations() {
        CloudKitManager.getLocations { result in
            switch result {
            case .success(let locations):
                self.locations = locations
            case .failure(_):
                self.alertItem = AlertContext.unableToGetLocation
            }
        }

    }
}
