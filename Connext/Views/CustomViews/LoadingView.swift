//
//  LoadingView.swift
//  Connext
//
//  Created by Turan Çabuk on 19.08.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            ProgressView()
                .tint(Color.brandPrimaryColor)
                .scaleEffect(2)
                .offset(y: -40)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    LoadingView()
}
