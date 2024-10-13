//
//  LocationsListView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var locationManager  : LocationManager
    @StateObject private var viewmodel              = LocationsListViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                if viewmodel.isLoading {
                    ZStack{
                        LoadingView()
                        Text("Loading...")
                            .padding(.top, 24)
                    }
                }else {
                    List{
                        ForEach(locationManager.locations) { location in
                            NavigationLink(value: location) {
                                LocationCell(location: location,profiles: viewmodel.checkedInProfiles[location.id, default: []])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .navigationDestination(for: Location.self, destination: { location in
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            })
            .task {viewmodel.getCheckedInProfilesDictionary()}
            .alert(item: $viewmodel.alertItem, content: {$0.alert})
        }
    }
}
#Preview {
    LocationsListView()
}
