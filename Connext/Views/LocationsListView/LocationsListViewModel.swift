//
//  LocationsListViewModel.swift
//  Connext
//
//  Created by Turan Çabuk on 3.10.2024.
//

import CloudKit

final class LocationsListViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [CKRecord.ID : [Profile]] = [:]
    @Published var isLoading        : Bool = false
    
    func getCheckedInProfilesDictionary() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let checkedProfiles):
                    checkedInProfiles = checkedProfiles
                case .failure(let error):
                    print(error.localizedDescription)
                }
                hideLoadingView()
            }
        }
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
