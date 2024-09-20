//
//  LocationsDetailView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct LocationsDetailView: View {
    
    @ObservedObject var viewmodel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            VStack{
                BannerView(location: viewmodel.location)
                BuildInformationView(viewmodel: viewmodel, location: viewmodel.location)
                UsersView(columns: viewmodel.columns, viewmodel: viewmodel)
            }
            .navigationBarTitle(viewmodel.location.name)
            .navigationBarTitleDisplayMode(.inline)
            
            if viewmodel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .transition(.opacity)
                    .animation(.easeOut)
                    .zIndex(1)
                ProfileModalView(isShowingProfileModal: $viewmodel.isShowingProfileModal,
                                 profile: Profile(record: MockData.profile))
                .transition(.opacity.combined(with: .slide))
                .animation(.easeOut)
                .zIndex(2)
            }
        }
    }
}

struct BannerView: View {
    
    var location: Location
    
    var body: some View {
        Image(uiImage: location.createBannerImage())
            .resizable()
            .scaledToFit()
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
    
    var viewmodel: LocationDetailViewModel
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
                    viewmodel.getDirectionsToLocation()
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
    var viewmodel: LocationDetailViewModel
    
    var body: some View {
        Text("Who's Here?")
            .bold()
            .font(.title2)
            .padding(.top)
        LazyVGrid(columns: columns, content: {
            ForEach(0..<1) { _ in
                VStack {
                    AvatarView(image: PlaceHolderImage.avatar, size: 48)
                    Text("user name")
                        .bold()
                        .lineLimit(1) 
                        .minimumScaleFactor(0.75)
                }
                .onTapGesture {
                    viewmodel.isShowingProfileModal = true
                }
            }
        })
        Spacer()
    }
}

#Preview {
    LocationsDetailView(viewmodel: LocationDetailViewModel(location: Location(record: MockData.location)))
}
