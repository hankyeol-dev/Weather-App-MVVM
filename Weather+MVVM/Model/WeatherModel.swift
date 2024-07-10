//
//  WeatherModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    
    var calcTemps: [Double] {
        return [self.temp, self.temp_min, self.temp_max].map {
            (($0 - 273.15) * 10).rounded() / 10
        }
    }

}

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct WeatherResult: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct ForecastResult: Decodable {
    let list: [WeatherResult]
}
