//
//  MapAnnotationView.swift
//  Connext
//
//  Created by Turan Çabuk on 4.10.2024.
//

import SwiftUI

struct MapAnnotationView: View {
    
    var location: Location
    var number  : Int
    
    var body: some View {
        VStack {
            ZStack {
                MapBaloonShape()
                    .frame(width: 100, height: 70)
                    .foregroundColor(Color.brandPrimary)
                Image(uiImage: location.createSquareImage())
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(.infinity)
                    .offset(y: -11)
                if number > 0 {
                    Rectangle()
                        .frame(width: 36, height: 30)
                        .foregroundColor(Color.pink)
                        .cornerRadius(12)
                        .offset(x: 20, y: -36)
                    Text("\(number)")
                        .bold()
                        .foregroundColor(Color.white)
                        .offset(x: 20, y: -36)
                }
            }
            Text(location.name)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    MapAnnotationView(location: Location(record: MockData.location), number: 55)
}
