//
//  WeatherOuput.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

struct WeatherDataReturnType {
    var city: String
    var currentTemps: [Double]
    var description: String
    var icon: String
}

struct WeatherOuput {
    var ok: Bool
    var error: String?
    var data: WeatherDataReturnType?
}
