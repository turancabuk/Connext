//
//  Profile.swift
//  Connext
//
//  Created by Turan Çabuk on 8.08.2024.
//

import CloudKit
import UIKit

struct Profile: Identifiable {
    static let kBio                 = "bio"
    static let kCompanyName         = "companyName"
    static let kFirstName           = "firstName"
    static let kLastName            = "lastName"
    static let kAvatar              = "avatar"
    static let kIsCheckedIn         = "isCheckedIn"
    static let kIsCheckedInNilCheck = "isCheckedInNilCheck"
    
    let bio, companyName, firstName, lastName : String
    let avatar: CKAsset!
    let isCheckedIn: CKRecord.Reference? 
    let id: CKRecord.ID
    
    init(record: CKRecord) {
        id      = record.recordID
        bio             = record[Profile.kBio] as? String ?? "N/A"
        companyName     = record[Profile.kCompanyName] as? String ?? "N/A"
        firstName       = record[Profile.kFirstName] as? String ?? "N/A"
        lastName        = record[Profile.kLastName] as? String ?? "N/A"
        avatar          = record[Profile.kAvatar] as?  CKAsset
        isCheckedIn     = record[Profile.kIsCheckedIn] as? CKRecord.Reference
    }
    
    func createAvatarImage() -> UIImage {
        guard let avatar = avatar else {return PlaceHolderImage.avatar}
        return avatar.convertToUIImage(dimension: .square)
    }
}
