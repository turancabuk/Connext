//
//  ProfileView.swift
//  Connext
//
//  Created by Turan Çabuk on 5.08.2024.
//

import SwiftUI
import PhotosUI
import CloudKit

struct ProfileView: View {
    
    @StateObject private var viewmodel  = ProfileViewModel()
    @State private var photosPickerItem : PhotosPickerItem?
    
    
    var body: some View {
        ZStack {
            VStack{
                PersonalInfoView(photosPickerItem: $photosPickerItem, viewmodel: viewmodel)
                BioInfoView(viewmodel: viewmodel)
                ButtonView(viewmodel: viewmodel, color: .brandPrimary)
            }
            if viewmodel.isLoadingView {LoadingView()}
        }
        .onAppear {
            viewmodel.getProfile()
            viewmodel.getCheckedInStatus()
        }
    }
}
fileprivate struct PersonalInfoView: View {
    
    @Binding var photosPickerItem: PhotosPickerItem?
    @StateObject var viewmodel: ProfileView.ProfileViewModel
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .frame(height: 120)
                .foregroundColor(.gray)
                .cornerRadius(24)
            HStack {
                ZStack {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(uiImage: viewmodel.avatarImage ?? UIImage(imageLiteralResourceName: "person"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 92, height: 92)
                            .cornerRadius(.infinity)
                            .padding(.horizontal, 12)
                    }
                    Button(action: {}, label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            .offset(y: 32)
                    })
                }
                VStack(alignment: .leading, spacing: 0){
                    TextField("First Name", text: $viewmodel.name).font(.system(size: 32, weight: .bold))
                    TextField("Second Name", text: $viewmodel.lastName).font(.system(size: 32, weight: .bold ))
                    TextField("Company Name", text: $viewmodel.companyName).font(.title)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            }
        }
        .padding(.horizontal, 8)
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        viewmodel.avatarImage = image
                    }
                }
                photosPickerItem = nil
            }
        }
    }
}

fileprivate struct BioInfoView : View {
    
    @StateObject var viewmodel: ProfileView.ProfileViewModel
    
    var body: some View {
        HStack {
            Text("Bio:")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Text("\(100 - viewmodel.bio.count)")
                .bold()
                .foregroundColor(viewmodel.bio.count <= 100 ? .brandPrimaryColor : Color(.systemPink))
            Text("characters remain")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
            if viewmodel.isCheckedIn {
                Button {viewmodel.checkOut()} label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 96, height: 28)
                            .foregroundColor(viewmodel.isCheckedIn ? Color.pink : Color.gray)
                            .cornerRadius(12)
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                            Text("Check Out")
                                .frame(height: 20)
                                .foregroundColor(Color.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 4)
        .padding()
        
        TextEditor(text: $viewmodel.bio)
            .frame(height: 100, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
            .padding(.horizontal)
        Spacer()
    }
}

fileprivate struct ButtonView: View {
    
    @StateObject var viewmodel: ProfileView.ProfileViewModel
    var color                 : Color = .brandPrimaryColor
    
    var body: some View {
        HStack {Button{ viewmodel.profileContext == .create ? viewmodel.createProfile() : viewmodel.updateProfile()} label: {
            Text(viewmodel.profileContext == .create ? "Create Profile" : "Update Profile")
                .bold()
                .frame(width: 280, height: 50)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(20)
        }
        .padding(.bottom, 16)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceType.isiPhone8Standard ? .inline : .automatic)
        .toolbar{
            Button(action: {
                dismissKeyboard()
            }, label: {
                Image(systemName: "keyboard.chevron.compact.down")
            })
        }
        .alert(item: $viewmodel.alertItem, content: { $0.alert})
        }
    }
}

#Preview {
    ProfileView()
}
