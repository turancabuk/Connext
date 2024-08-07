//
//  ProfileView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var name: String         = ""
    @State private var lastName: String     = ""
    @State private var companyName: String  = ""
    @State private var bio: String          = ""
    
    var body: some View {
        VStack{
            ZStack {
                Color(.secondarySystemBackground)
                    .frame(height: 120)
                    .foregroundColor(.gray)
                    .cornerRadius(24)
                HStack {
                    ZStack {
                        Image("person")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 104, height: 104)
                            .cornerRadius(.infinity)
                            .padding(.horizontal, 12)
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            .offset(y: 40)
                    }
                    VStack(alignment: .leading, spacing: 0){
                        TextField("First Name", text: $name)
                            .font(.system(size: 32, weight: .bold))
                        TextField("Second Name", text: $lastName)
                            .font(.system(size: 32, weight: .bold ))
                        TextField("Company Name", text: $companyName)
                            .font(.title)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    Spacer()
                }
            }
            .padding(.horizontal, 4)
            HStack {
                Text("Bio: \(19) characters remain")
                    .font(.system(size: 12))
                Spacer()
                ZStack{
                    Color(.systemPink)
                        .frame(width: 96, height: 28)
                        .foregroundColor(.pink)
                        .cornerRadius(12)
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Check Out")
                            .font(.system(size: 10))
                    }
                }
            }
            .padding()
            ZStack{
                Color(.secondarySystemBackground)
                    .frame(height: 140)
                    .cornerRadius(12)
                    .foregroundColor(.white )
                    .shadow(color: .primary, radius: 2)
                    .padding(.horizontal, 8)
                Text("I create Indie iOS Applications for my portfolio")
            }
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
