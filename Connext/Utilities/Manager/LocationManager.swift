//
//  LocationManager.swift
//  Connext
//
//  Created by Turan Çabuk on 12.08.2024.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [Location] = []
}
