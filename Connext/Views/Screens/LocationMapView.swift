//
//  LocationMapView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @State private var region = MKCoordinateRegion(
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
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region)
            
            VStack {
                Image("connext.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top)
                Spacer()
            }
        }
        .onAppear{
            CloudKitManager.getLocations { result in
                switch result {
                case .success(let locations):
                    print(locations)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    LocationMapView()
}
