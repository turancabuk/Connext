//
//  AppTabView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }            
            LocationsListView()
                .tabItem {
                    Label("Locations", systemImage: "building.2.crop.circle")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(Color.brandPrimary)
    }
}
#Preview {
    AppTabView()
}
