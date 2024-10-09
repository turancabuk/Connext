//
//  AlertItem.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import SwiftUI

struct AlertItem      : Identifiable {
    let id            = UUID()
    let title         : Text
    let message       : Text
    let dismissButton : Alert.Button
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

struct AlertContext {
    
    //MARK: - MapView Alerts.
    static let unableToGetLocations = AlertItem(
        title         : Text("Locations Error"),
        message       : Text("Unable to retrieve locations at this time.\nPlease try again."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let locationRestricted = AlertItem(
        title         : Text("Location Restricted!"),
        message       : Text("Please allow location settings to use it."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let locationDenied = AlertItem(
        title         : Text("Location Denied!"),
        message       : Text("Please allow location settings to use it."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let locationDisabled = AlertItem(
        title         : Text("Location Disabled!"),
        message       : Text("Please check your phone's Settings > Privacy > Location Services."),
        dismissButton : .default(Text("Ok"))
    )
    
    //MARK: - Profile View Alert.
    static let invalidProfile = AlertItem(
        title         : Text("Inavlid Profile!"),
        message       : Text("All fields are required."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let noUserRecord = AlertItem(
        title         : Text("Error!"),
        message       : Text("You must log in to your iCloud account."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let profileCreateFailure = AlertItem(
        title         : Text("Error!"),
        message       : Text("Failed to create profile. Please try again"),
        dismissButton : .default(Text("Ok" ))
    )
    
    static let unableToGetProfile = AlertItem(
        title         : Text( "Error!"),
        message       : Text("You have no profile. \nPlease create one."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let profileSavingFailure = AlertItem(
        title         : Text("Error!"),
        message       : Text("Profile created failed. \nPlease try again"),
        dismissButton : .default(Text("Ok"))
    )
    
    static let profileSavingSuccesfull = AlertItem(
        title         : Text("Suuces!"),
        message       : Text("Profile created succesfull."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let profileUpdatingFailure = AlertItem(
        title         : Text("Error!"),
        message       : Text("Profile updating failure. \nPlease try again"),
        dismissButton : .default(Text("Ok"))
    )
    
    static let profileUpdatingSuccesfull = AlertItem(
        title         : Text("Succes!"),
        message       : Text("Profile updated succesfull."),
        dismissButton : .default(Text("Ok"))
    )
    
    //MARK: - Location View Alerts.
    
    static let unableToGetCheckInStatus = AlertItem(
        title         : Text("Server error!"),
        message       : Text("Unable to retrieve check-in status."),
        dismissButton : .default(Text("Ok"))
    )
    
    static let unableToGetCheckInorOut = AlertItem(
        title         : Text("Server error!"),
        message       : Text("We are unable to retrieve check-in or out status."),
        dismissButton : .default(Text("Ok"))
    )

    static let checkedInCount = AlertItem(
        title         : Text("Server error!"),
        message       : Text("We are unable to get number of the people checked in."),
        dismissButton : .default(Text("Ok"))
    )
}
