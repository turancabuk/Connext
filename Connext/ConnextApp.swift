//
//  ConnextApp.swift
//  Connext
//
//  Created by Turan Çabuk on 4.08.2024.
//

import SwiftUI

@main
struct ConnextApp: App {
    
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}

