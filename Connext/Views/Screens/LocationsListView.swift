//
//  LocationsListView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        NavigationView{
            List{
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationsDetailView(location: location)) {
                        LocationCell(location: location)
                    }
                }
            }
            .navigationTitle("Grub Spots")
        }
    }
}
#Preview {
    LocationsListView()
}
