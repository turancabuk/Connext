//
//  View+Ext.swift
//  Connext
//
//  Created by Turan Çabuk on 16.08.2024.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
