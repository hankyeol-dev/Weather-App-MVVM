//
//  GeocodingModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

struct City: Decodable {
    let en: String
    let ko: String?
}

struct CityNameResult: Decodable {
    let local_names: City
}

struct CountryCoord: Decodable {
    let lon: Double
    let lat: Double
}

struct Country: Decodable {
    let id: Int
    let name: String
    let coord: CountryCoord
}
