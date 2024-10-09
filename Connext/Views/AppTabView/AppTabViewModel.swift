//
//  AppTabViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 5.10.2024.
//

import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: ObservableObject {
        let kHasSeenOnboardView             = "kHasSeenOnboardView"
        @Published var isShowingOnboardView = false
        @AppStorage("kHasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }
        
        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView { hasSeenOnboardView = true}
        }
    }
}
