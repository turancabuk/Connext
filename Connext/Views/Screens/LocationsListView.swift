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
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                        LocationCell(location: location)
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .onAppear {
                CloudKitManager.shared.getCheckedInPorfilesDictionary { result in
                    switch result {
                    case .success(let checkedInProfiles):
                        print("checkedInProfiles: \(checkedInProfiles)")
                    case .failure(_):
                        print("error checkedInProfiles")
                    }
                }
            }
        }
    }
}
#Preview {
    LocationsListView()
}
