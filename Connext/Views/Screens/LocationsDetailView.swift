//
//  LocationsDetailView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsDetailView: View {
    
    var location: Location
    let columns = [GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100))]
    
    let label: String = "hello"
    var body: some View {
        NavigationView {
            VStack{
                BannerView(location: location)
                BuildInformationView(location: location)
                UsersView(columns: columns)
            }
        }
        .navigationBarTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct BannerView: View {
    
    var location: Location
    
    var body: some View {
        Image("connext.banner")
            .resizable()
            .scaledToFill()
            .frame(height: 120)
        HStack{
            Label(location.adress, systemImage: "mappin.and.ellipse")
                .foregroundColor(.gray)
                .padding(.vertical, 6)
                .padding(.leading, 16)
                .font(.subheadline)
            Spacer()
        }
        .padding(.horizontal)
        Spacer()
    }
}
struct BuildInformationView: View {
    
    var location: Location
    
    var body: some View {
        Text(location.description)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .padding(.vertical)
        ZStack{
            Capsule()
                .frame(height: 80)
                .foregroundColor(Color(.secondarySystemBackground))
            HStack(spacing: 20){
                Button{
                    
                }label: {
                    LocationActionButton(color: .brandPrimaryColor, imageName: "location.fill")
                }
                Link(destination: URL(string: location.websiteURL)!, label: {
                    LocationActionButton(color: .brandPrimaryColor, imageName: "network")
                })
                Button{
                    
                }label: {
                    LocationActionButton(color: .brandPrimaryColor, imageName: "phone")
                }
                Button{
                    
                }label: {
                    LocationActionButton(color: .red, imageName: "person.fill.xmark")
                }
            }
        }
        .padding()
    }
}
struct LocationActionButton: View {
    
    let color: Color
    let imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(color)
            Image(systemName: imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }
}
struct UsersView: View {
    
    let columns: [GridItem]
    
    var body: some View {
        Text("Who's Here?")
            .bold()
            .font(.title2)
            .padding(.top)
        LazyVGrid(columns: columns, content: {
            ForEach(0..<7) { _ in
                VStack {
                    AvatarView(size: 48)
                    Text("user name")
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
        })
        Spacer()
    }
}
#Preview {
    LocationsDetailView(location: Location(record: MockData.location))
}
