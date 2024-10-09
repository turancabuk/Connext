//
//  ConnextButton.swift
//  Connext
//
//  Created by Turan Çabuk on 7.08.2024.
//

import SwiftUI

struct ConnextButton: View {
    
    var title       : String?
    var width       : CGFloat?
    var height      : CGFloat?
    var cornerRadius: CGFloat?
    
    var body: some View {
        Button(action: {}, label: {
            Text(title ?? "")
                .bold()
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .background(.brandPrimary)
                .cornerRadius(cornerRadius ?? 0)})
    }
}

#Preview {
    ConnextButton()
}
