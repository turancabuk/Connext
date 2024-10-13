//
//  CloudKitManager.swift
//  Connext
//
//  Created by Turan Çabuk on 9.08.2024.
//

import CloudKit

final class CloudKitManager {
    
    static let shared   = CloudKitManager()
    let container       = CKContainer.default()
    var userRecord      : CKRecord?
    var profileRecordID : CKRecord.ID?
    
    private init() {}
    
    func fetchRecord(id: CKRecord.ID) async throws -> CKRecord {
        return try await container.publicCloudDatabase.record(for: id)
    }
    
    func getUserRecord() async throws {
        let recordID = try await container.userRecordID()
        let record   = try await container.publicCloudDatabase.record(for: recordID)
        userRecord = record
        
        if let profileReference  = record["ConnextProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    func getLocations() async throws -> [Location] {
        let sortDescriptor = NSSortDescriptor(key: Location.kName, ascending: true)
        let query          = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        
        let (matchResult, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResult.compactMap { _, result in try? result.get()}
        return records.map { $0.convertToLocation() }
    }
    
    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [Profile] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query     = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get()}
        return records.map { $0.convertToProfile() }
    }
    
    func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID : [Profile]] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query     = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID : [Profile]] = [:]
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get()}
        
        for record in records {
            let profile = Profile(record: record)
            guard let locationReference = record[Profile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        guard let cursor else { return checkedInProfiles }
        
        do {
            return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    private func continueWithCheckedInProfilesDict(cursor: CKQueryOperation.Cursor,
                                                   dictionary: [CKRecord.ID: [Profile]]) async throws -> [CKRecord.ID: [Profile]] {
        
        var checkedInProfiles = dictionary
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        for record in records {
            let profile = Profile(record: record)
            guard let locationReference = record[Profile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        guard let cursor else { return checkedInProfiles }

        do {
            return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    func getCheckedInProfilesCount() async throws -> [CKRecord.ID : Int] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query     = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID : Int] = [:]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query, desiredKeys: [Profile.kIsCheckedIn])
        let records = matchResults.compactMap { _, result in try? result.get()}
        
        for record in records {
            guard let locationReference = record[Profile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            }else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        return checkedInProfiles
    }
    
    func save(for record: CKRecord) async throws -> CKRecord {
        return try await container.publicCloudDatabase.save(record)
    }
    
    func batchSave(for records: [CKRecord]) async throws -> [CKRecord] {
        let (savedResults, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResults.compactMap { _, result in try? result.get()}
    }
}
