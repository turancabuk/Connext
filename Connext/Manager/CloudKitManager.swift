//
//  CloudKitManager.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import CloudKit

struct CloudKitManager {
    
    static func getLocations(completed: @escaping(Result<[Location], Error>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: Location.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            guard let records = records else {return}
            let locations = records.map {$0.convertToLocation()}
            completed(.success(locations))
        }
    }
}
