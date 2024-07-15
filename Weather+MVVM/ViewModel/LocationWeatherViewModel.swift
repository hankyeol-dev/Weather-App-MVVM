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
                Task {
                    await self.findCityAndAdd(for: coord)
                }
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
    
    private func findCityAndAdd(for input: CountryCoord) async {
        apiManager?.fetch(to: FetchWeatherDTO(type: .forecast(lat: input.lat, lon: input.lon)), handler: { (data: ForecastCityResult?, error) in
            if let error { print(error) }
            if let city = data?.city {
                self.repository?.addSearch(SearchModel(id: city.id, name: city.name, lat: city.coord.lat, lon: city.coord.lon))
            }
        })
    }
    
    func getCurrentCityInfo() -> Country {
        self.fetchCityInfo() 
        return self.currentCity
    }
}
