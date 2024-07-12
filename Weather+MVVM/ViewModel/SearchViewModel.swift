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
    var addButtonInput = ValueObserver(0)
    var deleteButtonInput = ValueObserver(0)
    var buttonActionOuput = ValueObserver<Void?>(nil)

    var searchOutput = ValueObserver<[SearchCityOutput]>([])
    
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
        
        addButtonInput.bind(0) { input in
            if input != 0 {
                self.addCity(input)
            }
        }
        
        deleteButtonInput.bind(0) { input in
            if input != 0 {
                self.deleteCity(input)
            }
        }
    }
    
    private func fetchCity() {
        let total = self.apiManager?.loadLocalJSON()
        
        if let total {
            self.searchList = total
            self.searchOutput.value = self.mappingToSearchOuput(for: total)
        }
    }
    
    private func searchCity(_ keyword: String?) {
        guard let keyword else { return }
        
        if keyword.isEmpty {
            self.searchOutput.value = self.mappingToSearchOuput(for: searchList)
        } else {
            self.searchOutput.value = self.mappingToSearchOuput(for: searchList.filter({ $0.name.contains(keyword) }))
        }
    }
    
    private func isSelectedCity(for country: Country) -> Bool {
        var returns = false
        repository?.readSearch(dataHandler: { datas, error in
            guard error == nil else {
                returns = false
                return
            }
            
            if let datas {
                if datas.filter({ $0.id == country.id }).count != 0 {
                    returns = true
                }
            }
        })
        
        return returns
    }
    
    private func mappingToSearchOuput(for countries: [Country]) -> [SearchCityOutput] {
        return countries.map {
            SearchCityOutput(isSelected: self.isSelectedCity(for: $0), country: $0)
        }
    }
    
    private func addCity(_ cityId: Int) {
        let city = searchList.filter({ $0.id == cityId }).first
        if let city {
            repository?.addSearch(SearchModel(id: cityId, name: city.name, lat: city.coord.lat, lon: city.coord.lon))
            buttonActionOuput.value = ()
        }
    }
    
    private func deleteCity(_ cityId: Int) {
        repository?.readSearchById(cityId) { data, error in
            if let error {
                print(error.rawValue)
            }
            
            if let data {
                self.repository?.deleteSearch(for: data)
                self.buttonActionOuput.value = ()
            }
        }
    }
}
