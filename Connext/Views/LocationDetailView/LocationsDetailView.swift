//
//  LocationsDetailView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//


import SwiftUI

struct LocationDetailView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)
                
                HStack {
                    AddressView(address: viewModel.location.adress)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
                DescriptionView(text: viewModel.location.description)
                
                ZStack {
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))
                    
                    HStack(spacing: 20) {
                        Button {
                            viewModel.getDirectionsToLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        })
                        Button {
                            viewModel.callLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                        }
                        if let _ = CloudKitManager.shared.profileRecordID {
                            Button{
                                viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                            }label: {
                                LocationActionButton(color: viewModel.isCheckedIn ? .red : .blue, imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark")
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Text("Who's Here?")
                    .bold()
                    .font(.title2)
                
                ZStack {
                    if viewModel.checkedProfiles.isEmpty {
                        Text("Nobody's Here 😔")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: viewModel.columns, alignment: .leading, content: {
                                ForEach(viewModel.checkedProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            viewModel.isShowingProfileModal = true
                                            viewModel.show(profile, in: self.sizeCategory)
                                        }
                                }
                            })
                            .padding(.horizontal, 18)
                        }
                    }
                    
                    if viewModel.isLoadingView { LoadingView() }
                }
                Spacer()
            }
            if viewModel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal,
                                 profile: viewModel.selectedProfile!)
                .transition(.opacity.combined(with: .slide))
                .animation(.easeOut)
                .zIndex(2)
            }
        }
        .onAppear {
            viewModel.getCheckedProfiles()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert})
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .shadow(color: .black, radius: 2)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
            
        }
    }
}


fileprivate struct FirstNameAvatarView: View {
    
    var profile: Profile
    
    var body: some View {
        VStack {
            AvatarView(image: profile.avatarImage, size: 64)
            
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
            .frame(height: 120)
    }
}

fileprivate struct AddressView: View {
    
    var address: String
    
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

fileprivate struct DescriptionView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(12)
            .minimumScaleFactor(0.75)
            .frame(height: 120)
            .padding(.horizontal, 8)
    }
}

#Preview  {
    NavigationStack {
        LocationDetailView(viewModel: LocationDetailViewModel(location: Location(record: MockData.location)))
    }
}
