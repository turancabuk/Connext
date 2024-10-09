//
//  AvatarView.swift
//  Connext
//
//  Created by Turan Çabuk on 7.08.2024.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size : CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .cornerRadius(.infinity)
            .foregroundStyle(.brandPrimary)
    }
}
#Preview {
    AvatarView(image: PlaceHolderImage.avatar, size: 40)
}
