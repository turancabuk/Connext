//
//  ProfileView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State var bio: String    = "selamlar"
    
    var body: some View {
        VStack{
            PersonalInfoView()
            DescriptionView(bio: bio)
            BioView(bio: bio)
        }
    }
}
struct PersonalInfoView: View {
    
    @State private var name: String         = ""
    @State private var lastName: String     = ""
    @State private var companyName: String  = ""
    
    var body: some View {
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
                        .frame(width: 92, height: 92)
                        .cornerRadius(.infinity)
                        .padding(.horizontal, 12)
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .offset(y: 32)
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
            }
        }
        .padding(.horizontal, 8)
    }
}
struct DescriptionView: View {
    
    let bio: String
    
    var body: some View {
        HStack {
            Text("Bio:")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Text("\(100 - bio.count)")
                .bold()
                .foregroundColor(bio.count <= 100 ? .brandPrimaryColor : Color(.systemPink))
            Text("characters remain")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
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
        .padding(.horizontal, 4)
        .padding()
    }
}
struct BioView: View {
    
    @State var bio: String
    
    var body: some View {
        VStack{
            TextEditor(text: $bio)
                .frame(height: 100, alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                .padding(.horizontal)
        }
        Spacer()
        HStack {
            Button(action: {}, label: {
                Text("Create Profile")
                    .bold()
                    .frame(width: 280, height: 50)
                    .foregroundColor(.white)
                    .background(.brandPrimary)
                    .cornerRadius(20)
                    .padding(.bottom, 16)
            })
        }
    }
}
#Preview {
    ProfileView()
}
