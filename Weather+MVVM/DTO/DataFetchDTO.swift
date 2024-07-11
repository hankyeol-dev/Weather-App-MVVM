//
//  DataFetchDTO.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import Foundation

protocol FetchDTO { }

struct FetchWeatherDTO: FetchDTO {
    let type: APIService.RequestType
    
    var path: String {
        switch self.type {
        case .current:
            return PATH_MAIN + "weather"
        case .forecast:
            return PATH_MAIN + "forecast"
        case .cityname:
            return PATH_CITY
        }
    }
    
    var queryString: [URLQueryItem] {
        switch self.type {
        case .current(let id):
            return [
                URLQueryItem(name: "id", value: String(id)),
                URLQueryItem(name: "appId", value: APIKEY)
            ]
        case .forecast(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lon)),
                URLQueryItem(name: "appId", value: APIKEY)
            ]
        case .cityname(let name):
            return [
                URLQueryItem(name: "q", value: name),
                URLQueryItem(name: "limit", value: "1"),
                URLQueryItem(name: "appId", value: APIKEY)
            ]
        }
    }
}
