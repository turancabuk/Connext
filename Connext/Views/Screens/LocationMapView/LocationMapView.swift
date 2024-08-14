//
//  LocationMapView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapMarker(coordinate: location.location.coordinate, tint: .brandPrimaryColor)
            }
            .accentColor(.brandSecondaryColor)
            VStack {
                Image("connext.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top)
                Spacer()
            }
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .onAppear {
            viewModel.checkIfLocationServiceIsEnabled()
            
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
        }
    }
}

#Preview {
    LocationMapView()
}
