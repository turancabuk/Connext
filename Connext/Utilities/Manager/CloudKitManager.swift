//
//  CloudKitManager.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    
    private init() {}
        
    func getUserRecord() {
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                
                if let profileReference = userRecord["ConnextProfile"] as? CKRecord.Reference {
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }
    
    func fetchRecord(id: CKRecord.ID, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(record))
        }
    }
    static func getLocations(completed: @escaping (Result<[Location], Error>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: Location.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            guard let records = records else { return }
            let locations = records.map { $0.convertToLocation() }
            completed(.success(locations))
        }
    }
    
    func batchSave(records: [CKRecord], completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            guard let savedRecords = savedRecords, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(savedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func save(record: CKRecord, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(record))
        }
    }
    
    func getCheckedInProfiles(for locationID: CKRecord.ID, completion: @escaping (Result<[Profile], Error>) -> Void) {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                guard let records = records, error == nil else {
                    completion(.failure(error!))
                    return
            }
            
            let profiles = records.map { $0.convertToProfile() }
            completion(.success(profiles))
        }
    }
    
    func getCheckedInProfilesDictionary(completion: @escaping (Result<[CKRecord.ID : [Profile]], Error>) -> Void) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        var checkedInProfiles: [CKRecord.ID : [Profile]] = [:]
        
        operation.recordFetchedBlock = { record in
            let profile = Profile(record: record)
            guard let locationReference = profile.isCheckedIn else { return }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else { return completion(.failure(error!)) }
            
            completion(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
