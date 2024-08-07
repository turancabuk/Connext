//
//  LocationsListView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsListView: View {
    var body: some View {
        NavigationView{
            List{
                ForEach(0..<10) { _ in
                    NavigationLink(destination: LocationsDetailView()) {
                        LocationCell()
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
