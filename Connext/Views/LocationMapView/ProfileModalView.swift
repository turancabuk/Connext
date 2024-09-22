//
//  ProfileModalView.swift
//  Connext
//
//  Created by Turan Çabuk on 23.08.2024.
//

import SwiftUI

struct ProfileModalView: View {
    
    @Binding var isShowingProfileModal: Bool
    var profile: Profile
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 36)
                Text(profile.firstName + " " + profile.lastName)
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                Text(profile.companyName)
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .bold()
                Text(profile.bio)
                    .lineLimit(4)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .frame(width: 300)
                    .padding()
            }
            .frame(width: 340, height: 230)
            .background(Color.gray)
            .cornerRadius(12)
            .overlay(
                Button {
                    withAnimation {
                        isShowingProfileModal = false
                    }
                } label: {
                    DismissButton()
                }, alignment: .topTrailing)
            
            Image(uiImage: profile.createAvatarImage())
                .resizable()
                .scaledToFill()
                .frame(width: 102, height: 102)
                .cornerRadius(.infinity)
                .shadow(color: .white, radius: 4)
                .offset(y: -120)
        }
    }
}

#Preview {
    ProfileModalView(isShowingProfileModal: .constant(true), profile: Profile(record: MockData.profile))
}
