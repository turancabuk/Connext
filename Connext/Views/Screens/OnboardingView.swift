//
//  OnboardingView.swift
//  Connext
//
//  Created by Turan Çabuk on 14.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    private var viewmodel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    DismissButton()
                })
                .padding(.trailing, 12 )
            }
            Spacer()
            Image("connext.transparent")
                .resizable()
                .scaledToFit()
                .cornerRadius(24)
                .frame(width: 180, height: 220)
                .shadow(color: .gray, radius: 14)
            
            VStack(alignment: .leading, spacing: 24) {
                viewmodel.createCustomOnboardingCell(imageName: "building.2.crop.circle", titleText: "Restaurant Locations", DescriptionText: "Find places to dine around the convention center")
                viewmodel.createCustomOnboardingCell(imageName: "checkmark.circle", titleText: "Check In", DescriptionText: "Let other Devs know where you are")
                viewmodel.createCustomOnboardingCell(imageName: "person.2.circle", titleText: "Find Friends", DescriptionText: "See where other iOS Devs are and join the party")
            }
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
