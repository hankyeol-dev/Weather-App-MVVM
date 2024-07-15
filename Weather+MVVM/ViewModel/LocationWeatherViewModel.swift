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
    
    var selectedCityInput = ValueObserver<CountryCoord?>(nil)
    
    init(repository: SearchRepository, apiManager: APIService) {
        self.repository = repository
        self.apiManager = apiManager
        
        self.selectedCityInput.bind(nil) { coord in
            if let coord {
                self.addCity(by: coord)
            }
        }
    }
    
    private func fetchCityInfo() {
        repository?.readSearch { search, error in
            if let error { print(error) }
            if let search, search.count != 0, let city = search.first {
                self.currentCity = Country(id: city.id, name: city.name, coord: CountryCoord(lat: city.lat, lon: city.lon))
            }
        }
    }
    
    private func addCity(by location: CountryCoord) {
        apiManager?.fetch(to: FetchWeatherDTO(type: .forecast(lat: location.lat, lon: location.lon))) { (data: ForecastCityResult?, error) in
            if let error {
                print(error.rawValue)
            }
            
            if let data {
                self.repository?.addSearch(SearchModel(id: data.city.id, name: data.city.name, lat: data.city.coord.lat, lon: data.city.coord.lon))
            }
        }
    }
    
    func getCurrentCityInfo() -> Country {
        self.fetchCityInfo()
        return self.currentCity
    }

}
