//
//  AppTabView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
    
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem {Label("Map", systemImage: "map")}
            
            LocationsListView()
                .tabItem {Label("Locations", systemImage: "building")}
            
            NavigationView {ProfileView()}
                .tabItem {Label("Profile", systemImage: "person")}
        }
        .task {
            try? await CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardView,  content: {
            OnboardingView()
        })
    }
}
#Preview {
    AppTabView()
}
