//
//  LocationsListView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsListView: View {
    
    @State private var location: [Location] = [Location(record: MockData.location)]
    
    var body: some View {
        NavigationView{
            List{
                ForEach(location, id: \.ckRecordID) { location in
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
