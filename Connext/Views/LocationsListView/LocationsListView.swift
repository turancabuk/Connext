//
//  LocationsListView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewmodel = LocationsListViewModel()
    
    var body: some View {
        NavigationView{
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
                            NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                                LocationCell(location: location,
                                             profiles: viewmodel.checkedInProfiles[location.id, default: []])
                            }
                        }
                    }
                    .navigationTitle("Grub Spots")
                }
            }
            .onAppear {
                viewmodel.getCheckedInProfilesDictionary()
            }
        }
    }
}
#Preview {
    LocationsListView()
}
