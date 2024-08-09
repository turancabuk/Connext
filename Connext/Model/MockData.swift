//
//  MockData.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import CloudKit

struct MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: "Location")
        record[Location.kName]          = "Turan's Bar & Grill"
        record[Location.kAdress]        = "123 W San Jose St #12"
        record[Location.kPhoneNumber]   = "090-243-564"
        record[Location.kDescription]   = "Best in town"
        record[Location.kWebsiteURL]    = "https://www.apple.com"
        record[Location.kLocation]      = CLLocation(latitude: 37.331516, longitude: -121.891054)
        return record
    }
}
