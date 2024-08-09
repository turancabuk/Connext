//
//  Location.swift
//  Connext
//
//  Created by Turan Çabuk on 8.08.2024.
//

import CloudKit

struct Location {
    static let kAdress = "adress"
    static let kDescription = "description"
    static let kName = "name"
    static let kPhoneNumber = "phoneNumber"
    static let kWebsiteURL = "websiteURL"
    static let kBannerAsset = "bannerAsset"
    static let kSquareAsset = "squareAsset"
    static let kLocation = "location"

    let adress, description, name, phoneNumber, websiteURL : String
    let bannerAsset, squareAsset: CKAsset!
    let location: CLLocation
    let ckRecordID: CKRecord.ID
    
    init(record: CKRecord) {
        ckRecordID  = record.recordID
        adress      = record[Location.kAdress] as? String ?? "N/A"
        description = record[Location.kDescription] as? String ?? "N/A"
        name        = record[Location.kName] as? String ?? "N/A"
        phoneNumber = record[Location.kPhoneNumber] as? String ?? "N/A"
        websiteURL  = record[Location.kWebsiteURL] as? String ?? "N/A"
        bannerAsset = record[Location.kBannerAsset] as? CKAsset
        squareAsset = record[Location.kSquareAsset] as? CKAsset
        location    = record[Location.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
    }
}
