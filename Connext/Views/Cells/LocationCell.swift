//
//  LocationCell.swift
//  Connext
//
//  Created by Turan Çabuk on 7.08.2024.
//

import SwiftUI

struct LocationCell: View {
    
    var location: Location
    
    var body: some View{
        HStack{
            AvatarView(size: 80)
            Spacer()
            VStack(alignment: .leading){
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                HStack(spacing: 4) {
                    ForEach(0..<4) { _ in
                        AvatarView(size: 48)
                    }
                }
                Spacer()
            }
        }
    }
}
#Preview {
    LocationCell(location: Location(record: MockData.location))
}
