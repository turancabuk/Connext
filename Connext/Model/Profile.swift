//
//  Profile.swift
//  Connext
//
//  Created by Turan Çabuk on 8.08.2024.
//

import CloudKit

struct Profile {
    static let kBio = "bio"
    static let kCompanyName = "companyName"
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kAvatar = "avatar"
    static let kIsCheckedIn = "isCheckedIn"

    let bio, companyName, firstName, lastName : String
    let avatar: CKAsset!
    let isCheckedIn: CKRecord.Reference? = nil
    let ckRecordID: CKRecord.ID
    
    init(record: CKRecord) {
        ckRecordID      = record.recordID
        bio             = record[Profile.kBio] as? String ?? "N/A"
        companyName     = record[Profile.kCompanyName] as? String ?? "N/A"
        firstName       = record[Profile.kFirstName] as? String ?? "N/A"
        lastName        = record[Profile.kLastName] as? String ?? "N/A"
        avatar          = record[Profile.kAvatar] as?  CKAsset
    }
}