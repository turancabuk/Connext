//
//  DismissButton.swift
//  Connext
//
//  Created by Turan Çabuk on 14.08.2024.
//

import SwiftUI

struct DismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.brandPrimaryColor)
            Image(systemName: "xmark")
                .frame(width: 44, height: 44)
                .imageScale(.medium)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    DismissButton()
}
