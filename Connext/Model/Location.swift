//
//  Location.swift
//  Connext
//
//  Created by Turan Çabuk on 8.08.2024.
//

import CloudKit
import UIKit

struct Location: Identifiable, Hashable {
    static let kAdress      = "adress"
    static let kDescription = "description"
    static let kName        = "name"
    static let kPhoneNumber = "phoneNumber"
    static let kWebsiteURL  = "websiteURL"
    static let kBannerAsset = "bannerAsset"
    static let kSquareAsset = "squareAsset"
    static let kLocation    = "Location"

    let adress, description, name, phoneNumber, websiteURL : String
    let bannerAsset, squareAsset: CKAsset!
    let location: CLLocation
    let id: CKRecord.ID
    
    init(record: CKRecord) {
        id          = record.recordID
        name        = record[Location.kName] as? String ?? "N/A"
        description = record[Location.kDescription] as? String ?? "N/A"
        squareAsset = record[Location.kSquareAsset] as? CKAsset
        bannerAsset = record[Location.kBannerAsset] as? CKAsset
        adress      = record[Location.kAdress] as? String ?? "N/A"
        location    = record[Location.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL  = record[Location.kWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[Location.kPhoneNumber] as? String ?? "N/A"
    }
    
    var squareImage: UIImage {
        guard let squareAsset else {return PlaceHolderImage.square}
        return squareAsset.convertToUIImage(dimension: .square)
    }

    var bannerImage: UIImage {
        guard let bannerAsset else {return PlaceHolderImage.banner}
        return bannerAsset.convertToUIImage(dimension: .banner)
    }
}
