//
//  SearchViewModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import Foundation

final class SearchViewModel {
    private var repository: SearchRepository?
    private var apiManager: APIService?
    
    private var searchList: [Country] = []
    var loadInput = ValueObserver<Void?>(nil)
    var searchInput = ValueObserver<String?>(nil)
    var searchOutput = ValueObserver<[Country]>([])
    
    init(repository: SearchRepository, manager: APIService) {
        self.repository = repository
        self.apiManager = manager
        
        triggerInput()
    }
    
    private func triggerInput() {
        loadInput.bind(nil) { input in
            guard input != nil else { return }
            self.fetchCity()
        }
        
        searchInput.bind("") { keyword in
            self.searchCity(keyword)
        }
        
    }
    
    private func fetchCity() {
        let total = self.apiManager?.loadLocalJSON()
        
        if let total {
            self.searchList = total
            self.searchOutput.value = total
        }
    }
    
    private func searchCity(_ keyword: String?) {
        guard let keyword else { return }
        
        if keyword.isEmpty {
            self.searchOutput.value = searchList
        } else {
            self.searchOutput.value = searchList.filter { $0.name.contains(keyword) }
        }
    }
}
