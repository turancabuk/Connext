//
//  LocationsListViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 3.10.2024.
//

import CloudKit

extension LocationsListView {
    @MainActor
    class LocationsListViewModel: ObservableObject {
        @Published var checkedInProfiles: [CKRecord.ID : [Profile]] = [:]
        @Published var isLoading        : Bool = false
        @Published var alertItem        : AlertItem?
        
        func getCheckedInProfilesDictionary() {
            showLoadingView()
            Task {
                do{
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                    hideLoadingView()
                }catch {
                    alertItem = AlertContext.checkedInCount
                    hideLoadingView()
                }
            }
        }
        
        func showLoadingView() { isLoading = true }
        func hideLoadingView() { isLoading = false }
    }
}
