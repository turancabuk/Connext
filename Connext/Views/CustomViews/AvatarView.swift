//
//  AvatarView.swift
//  Connext
//
//  Created by Turan Çabuk on 7.08.2024.
//

import SwiftUI

struct AvatarView: View {
    
    var size: CGFloat
    
    var body: some View {
        Image("person")
            .resizable()
            .frame(width: size, height: size)
            .cornerRadius(.infinity)

    }
}
#Preview {
    AvatarView(size: 40)
}
