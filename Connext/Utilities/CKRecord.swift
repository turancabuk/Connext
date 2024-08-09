//
//  CKRecord.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import CloudKit

extension CKRecord {
    func convertToLocation() -> Location {Location(record: self)}
    func convertToProfile()  -> Profile  {Profile(record: self)}
}
