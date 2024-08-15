//
//  OnboardingView.swift
//  Connext
//
//  Created by Turan Çabuk on 14.08.2024.
//

import SwiftUI

struct OnboardingView: View {
        
    @Binding var isShowingOnboardView: Bool
    
    var body: some View {
        ZStack {
            Color.onboarding.ignoresSafeArea()
            OnboardInfoView(showingOnboardView: $isShowingOnboardView)
        }
    }
}

struct OnboardInfoView: View {
    
    @Binding var showingOnboardView: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button(action: {
                    showingOnboardView = false
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
                .padding(.vertical, 12)

            VStack(alignment: .leading, spacing: 24) {
                createCustomOnboardingCell(imageName: "building.2.crop.circle", titleText: "Restaurant Locations", DescriptionText: "Find places to dine around the convention center")
                createCustomOnboardingCell(imageName: "checkmark.circle", titleText: "Check In", DescriptionText: "Let other iOS Devs know where you are")
                createCustomOnboardingCell(imageName: "person.2.circle", titleText: "Find Friends", DescriptionText: "See where other iOS Devs are and join the party")
            }
            Spacer()
        }
    }
}
// Factory Method.
func createCustomOnboardingCell(imageName: String, titleText: String, DescriptionText: String) -> some View {
    HStack(spacing: 48) {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 62, height: 62)
            .foregroundColor(Color.brandPrimaryColor)
        VStack(alignment: .leading, spacing: 6) {
            Text(titleText)
                .bold()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(DescriptionText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
    }
    .padding(.horizontal, 48)
}
#Preview {
    OnboardingView(isShowingOnboardView: .constant(true))
}
