//
//  LocationMapView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager  : LocationManager
    @StateObject private var viewModel              = LocationMapViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate) {
                    MapAnnotationView(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .accentColor(.brandSecondaryColor)
            Image("connext.transparent")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, content: {
            NavigationView {
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar {Button("Close") {viewModel.isShowingDetailView = false}}
            }
            .accentColor(.brandPrimary)
        })
        .alert(item: $viewModel.alertItem, content: { $0.alert})
        .onAppear {
            if locationManager.locations.isEmpty {viewModel.getLocations(for: locationManager)}
            viewModel.getCheckInCounts()
        }
    }
}

#Preview {
    LocationMapView()
}
