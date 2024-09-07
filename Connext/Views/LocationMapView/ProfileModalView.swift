//
//  ProfileModalView.swift
//  Connext
//
//  Created by Turan Çabuk on 23.08.2024.
//

import SwiftUI

struct ProfileModalView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 36)
                Text("Deneme")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                Text("YouTuber & Indie Dev")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .bold()
                Text("Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme Deneme ")
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
                    
                } label: {
                    DismissButton()
                }, alignment: .topTrailing)
            
            Image(uiImage: PlaceHolderImage.avatar)
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
    ProfileModalView()
}
