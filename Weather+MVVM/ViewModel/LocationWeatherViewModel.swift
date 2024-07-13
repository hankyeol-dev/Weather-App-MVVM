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
    
    
    
    init(repository: SearchRepository, apiManager: APIService) {
        self.repository = repository
        self.apiManager = apiManager
    }
}
