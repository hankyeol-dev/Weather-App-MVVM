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
    
    var getAdditionalWeather: [String: Double] {
        return [
            "바람" : self.wind.speed,
            "구름" : self.clouds.all,
            "기압" : self.main.pressure,
            "습도" : (self.main.humidity / 100.0) * 100.0
        ]
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
                return Calendar.current.compare(convert, to: Date(), toGranularity: .day) == .orderedDescending || Calendar.current.compare(convert, to: Date(), toGranularity: .day) == .orderedSame
            }
            return false
        }.map { Forecast(main: $0.main, weather: $0.weather, dt_txt: $0.dt_txt) }
    }
    
    var tempAvgs: [[Double]] {
        let max = self.list.split { cast in
            cast.dt_txt.contains("00:00:00")
        }.map { (($0.map { $0.main.temp_max }).reduce(0) { partialResult, next in
            partialResult + next
        }) / Double($0.count) }
        
        let min = self.list.split { cast in
            cast.dt_txt.contains("00:00:00")
        }.map { (($0.map { $0.main.temp_min }).reduce(0) { partialResult, next in
            partialResult + next
        }) / Double($0.count) }
        
        
        return [max, min].map { $0.map { (($0 - 273.15) * 10).rounded() / 10 } }
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

struct ForecastCity: Decodable {
    let id: Int
    let name: String
    let coord: CountryCoord
}

struct ForecastCityResult: Decodable {
    let city: ForecastCity
}
