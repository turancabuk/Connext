//
//  LocationCell.swift
//  Connext
//
//  Created by Turan Çabuk on 7.08.2024.
//

import SwiftUI

struct LocationCell: View {
    
    var location: Location
    var profiles: [Profile]
    
    var body: some View{
        HStack(){
            Image(uiImage: location.squareImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(.circle)
            VStack(alignment: .leading){
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                if profiles.isEmpty {
                    Text("This place's empty.")
                }else {
                    HStack{
                        ForEach(profiles.indices, id: \.self) { index in
                            if index <= 3 {
                                AvatarView(image: profiles[index].avatarImage, size: 42)
                            }else if index == 4 {
                                AdditionalProfilesView(number: self.profiles.count - 4)
                            }
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct AdditionalProfilesView: View {
    
    var number: Int
    
    var body: some View {
        Text("+\(number)")
            .frame(width: 42, height: 42)
            .bold()
            .background(.brandPrimary)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
    }
}
#Preview {
    LocationCell(location: Location(record: MockData.location), profiles: [])
}
