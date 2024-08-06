//
//  LocationsDetailView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsDetailView: View {
    
    let columns = [GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100)),
                   GridItem(.flexible(minimum: 20, maximum: 100))]
    
    var body: some View {
        NavigationView {
            VStack{
                BannerView()
                BuildInformationView()
                UsersView(columns: columns)
            }
        }
        .navigationBarTitle("personel name")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct BannerView: View {
    var body: some View {
        Image("connext.banner")
            .resizable()
            .scaledToFill()
            .frame(height: 120)
        HStack{
            Label("123 Sample adress", systemImage: "mappin.and.ellipse")
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
    var body: some View {
        Text("Sample Build Review")
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
                Link(destination: URL(string: "https://www.apple.com")!, label: {
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
                    Image("person")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 48)
                        .cornerRadius(.infinity)
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
    LocationsDetailView()
}
