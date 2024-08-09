//
//  AlertItem.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let text: String
    let message: String
    let dismisButton: Alert.Button
}

// MARK: - LocationMapView alert.
struct AlertContext {
    static let unableToGetLocation = AlertItem(text: "Location Error!", message: "Please try again.", dismisButton: .default(Text("ok")))
}
