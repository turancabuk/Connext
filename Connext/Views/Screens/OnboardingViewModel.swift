//
//  OnboardingViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 13.10.2024.
//

import SwiftUI

extension OnboardingView{
    
    class OnboardingViewModel: ObservableObject{
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
                        .foregroundColor(.black)
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
    }
}
