//
//  LocationsListViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 3.10.2024.
//

import CloudKit

extension LocationsListView {
    
    class LocationsListViewModel: ObservableObject {
        @Published var checkedInProfiles: [CKRecord.ID : [Profile]] = [:]
        @Published var isLoading        : Bool = false
        @Published var alertItem        : AlertItem?
        
        func getCheckedInProfilesDictionary() {
            showLoadingView()
            CloudKitManager.shared.getCheckedInProfilesDictionary { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let checkedProfiles):
                        checkedInProfiles = checkedProfiles
                    case .failure(_):
                        alertItem = AlertContext.checkedInCount
                    }
                    hideLoadingView()
                }
            }
        }
        
        func showLoadingView() { isLoading = true }
        func hideLoadingView() { isLoading = false }
    }
}
