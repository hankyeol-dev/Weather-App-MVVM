//
//  LocationWeatherViewModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/13/24.
//

import Foundation

final class LocationWeatherViewModel {
    private var repository: SearchRepository?
    private var apiManager: APIService?
    
    private var currentCity: Country = Country(id: SEOUL_CITY_ID, name: "Seoul", coord: CountryCoord(lat: SEOUL_LAT, lon: SEOUL_LON))
    
    init(repository: SearchRepository, apiManager: APIService) {
        self.repository = repository
        self.apiManager = apiManager
    }
    
    private func fetchCityInfo() {
        repository?.readSearch { search, error in
            if let error { print(error) }
            if let search, search.count != 0, let city = search.first {
                self.currentCity = Country(id: city.id, name: city.name, coord: CountryCoord(lat: city.lat, lon: city.lon))
            }
        }
    }
    
    
    func getCurrentCityInfo() -> Country {
        return self.currentCity
    }
}
