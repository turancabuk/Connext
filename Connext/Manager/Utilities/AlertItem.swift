//
//  AlertItem.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    //MARK: - MapView Alerts.
    static let unableToGetLocations = AlertItem(
        title: Text(
            "Locations Error"
        ),
        message: Text(
            "Unable to retrieve locations at this time.\nPlease try again."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
    
    static let locationRestricted = AlertItem(
        title: Text(
            "Location Restricted!"
        ),
        message: Text(
            "Please allow location settings to use it."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
    
    static let locationDenied = AlertItem(
        title: Text(
            "Location Denied!"
        ),
        message: Text(
            "Please allow location settings to use it."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
    
    static let locationDisabled = AlertItem(
        title: Text(
            "Location Disabled!"
        ),
        message: Text(
            "Please check your phone's Settings > Privacy > Location Services."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
    
    // Profile View Alert.
    static let invalidProfile = AlertItem(
        title: Text(
            "Inavlid Profile!"
        ),
        message: Text(
            "All fields are required."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )

    static let noUserRecord = AlertItem(
        title: Text(
            "Error!"
        ),
        message: Text(
            "You must log in to your iCloud account."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )

    static let profileFailure = AlertItem(
        title: Text(
            "Error!"
        ),
        message: Text(
            "Failed to create profile. Please try again"
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )

    static let unableToGetProfile = AlertItem(
        title: Text(
            "Error!"
        ),
        message: Text(
            "Unable to retrieve profile"
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
    
    static let profileSuccesfull = AlertItem(
        title: Text(
            "Suuces!"
        ),
        message: Text(
            "Profile created succesfull."
        ),
        dismissButton: .default(
            Text(
                "Ok"
            )
        )
    )
}
