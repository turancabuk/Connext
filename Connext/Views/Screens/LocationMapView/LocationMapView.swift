//
//  LocationMapView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @StateObject private var viewModel = LocationMapViewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region )
            
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
            Alert(title: Text(alertItem.text), message: Text(alertItem.message), dismissButton: alertItem.dismisButton)
        })
        .onAppear{
            viewModel.getLocations()
        }
    }
}

#Preview {
    LocationMapView()
}
