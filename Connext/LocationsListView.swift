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
struct LocationCell: View {
    var body: some View{
        HStack{
            Image("person")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(.infinity)
                .padding(.vertical, 8)
            Spacer()
            VStack(alignment: .leading){
                Text("Sample Location Title")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                HStack(spacing: 4) {
                    ForEach(0..<4) { _ in
                        Image("person")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .cornerRadius(.infinity)
                    }
                }
                Spacer()
            }
        }
    }
}
#Preview {
    LocationsListView()
}
