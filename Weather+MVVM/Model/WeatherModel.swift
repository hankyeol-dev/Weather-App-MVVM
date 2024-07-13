//
//  WeatherModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

struct Wind: Decodable {
    let speed: Double
}

struct Clouds: Decodable {
    let all: Double
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
    
    var calcTemps: [Double] {
        return [self.temp, self.temp_min, self.temp_max].map {
            (($0 - 273.15) * 10).rounded() / 10
        }
    }

}

struct Weather: Decodable {
    let id: Int
    let icon: String
}

struct WeatherResult: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
    let wind: Wind
    let clouds: Clouds
    
    var getWeather: Weather? {
        guard let weather = self.weather.first else { return nil }
        return weather
    }
}

struct Forecast: Decodable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    
    var getWeather: Weather? {
        guard let weather = self.weather.first else { return nil }
        return weather
    }
}

struct ForecastResult: Decodable {
    let list: [Forecast]
    
    var tempForcasts: [Forecast] {
        return list.filter {
            let d = DateFormatter()
            d.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let convert = d.date(from: $0.dt_txt)
            
            if let convert {
                return Calendar.current.compare(convert, to: Date(), toGranularity: .hour) == .orderedDescending
            }
            return false
        }.map { Forecast(main: $0.main, weather: $0.weather, dt_txt: $0.dt_txt) }
    }
    
    var tempAvgs: [[Double]] {
        let array = self.list.split { cast in
            cast.dt_txt.contains("00:00:00")
        }.map { $0.last }
        
        return array.map { $0!.main.calcTemps }
    }
    
    var tempDays: [String] {
        let array = self.list.map { $0.dt_txt }.split { date in
            date.contains("00:00:00")
        }.map { $0.first! }.map { $0.split(separator: " ")[0] }.map {
            String($0)
        }
        let array2 = array.map {
            let d = DateFormatter()
            d.dateFormat = "yyyy-MM-dd"
            let convert = d.date(from: $0)
            let c = DateFormatter()
            c.locale = Locale(identifier: "ko-KR")
            c.dateFormat = "E"
            return c.string(from: convert!)
        }
        
        return array2
    }
    
    var tempIcons: [String] {
        return self.list.split { forcast in
            forcast.dt_txt.contains("00:00:00")
        }.map { $0.first?.getWeather?.icon }.map {
            guard let icon = $0 else { return "01d" }
            return icon
        }
    }
}
