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
    
    @State var bio: String    = ""

    @State private var name: String         = ""
    @State private var lastName: String     = ""
    @State private var companyName: String  = ""
    @State private var avatarImage          : UIImage?
    @State private var photosPickerItem     : PhotosPickerItem?
    @State private var alertItem            : AlertItem?
    
    var body: some View {
        VStack{
            ZStack {
                Color(.secondarySystemBackground)
                    .frame(height: 120)
                    .foregroundColor(.gray)
                    .cornerRadius(24)
                HStack {
                    ZStack {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Image(uiImage: avatarImage ?? UIImage(imageLiteralResourceName: "person"))
                                .resizable()
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
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            avatarImage = image
                        }
                    }
                    photosPickerItem = nil
                }
            }
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
            TextEditor(text: $bio)
                .frame(height: 100, alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                .padding(.horizontal)
            Spacer()
            HStack {
                Button(action: {
                    createProfile()
                }, label: {
                    Text("Create Profile")
                        .bold()
                        .frame(width: 280, height: 50)
                        .foregroundColor(.white)
                        .background(.brandPrimary)
                        .cornerRadius(20)
                })
                    .padding(.bottom, 16)
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar{
                        Button(action: {
                            dismissKeyboard()
                        }, label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        })
                    }
                    .alert(item: $alertItem) { alertItem in
                        Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                    }
            }
        }
    }
    func createProfile() {
        guard checkRequirements() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[Profile.kFirstName] = name
        profileRecord[Profile.kLastName] = lastName
        profileRecord[Profile.kCompanyName] = companyName
        profileRecord[Profile.kBio] = bio
        profileRecord[Profile.kAvatar] = avatarImage?.convertToCKAsset()
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                userRecord["ConnextProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
                
                operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
                    guard let savedRecords = savedRecords, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    print(savedRecords)
                }
                CKContainer.default().publicCloudDatabase.add(operation)
            }
        }
    }
    
    func checkRequirements() -> Bool {
        guard !name.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              avatarImage != nil,
              bio.count <= 100
        else {return false}
        return true
    }
}
#Preview {
    ProfileView()
}
