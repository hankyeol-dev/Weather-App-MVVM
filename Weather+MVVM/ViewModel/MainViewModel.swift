//
//  MainViewModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

final class MainViewModel {
    private var repository: SearchRepository?
    private let manager = APIService.manager
    
    private var currentCity: Country = Country(id: SEOUL_CITY_ID, name: "Seoul", coord: CountryCoord(lat: SEOUL_LAT, lon: SEOUL_LON))
    var viewDidInput = ValueObserver<Void?>(nil)
    var currentWeatherOutput = ValueObserver<WeatherOuput?>(nil)
    var forecastDataOutput = ValueObserver<ForecastOutput?>(nil)
    
    init(repository: SearchRepository) {
        self.repository = repository
        self.viewDidInput.bind(nil) { value in
            guard value != nil else { return }
            self.fetchCurrentWeather()
            self.fetchForecast()
        }
    }
    
    private func mapDescription(for id: Int) -> String{
        switch id {
        case 801...804:
            return "구름이 끼어있는 날씨예요."
        case 700...799:
            return "뭔가 모르게 이상한 날씨예요. (태풍, 황사 등등)"
        case 600...699:
            return "눈 내리는 날씨예요."
        case 500...599:
            return "비 내리는 날씨예요."
        case 300...399:
            return "약한 비가 내리는 날씨예요."
        case 200...299:
            return "천둥 번개를 동반한 비가 내리는 날씨예요."
        default:
            return "구름 없이 맑은 날씨예요."
        }
    }
    
    private func fetchCurrentWeather() {
        // 1. 도시 정보를 먼저 DB에서 조회해서 가져오고
        fetchCityInfo()
        
        // 2. fetch
        DispatchQueue.global().async {
            var returns = WeatherDataReturnType(city: "", currentTemps: [], description: "", icon: "", additional: [:])
            self.manager.fetch(to: FetchWeatherDTO(type: .current(id: self.currentCity.id))) { (data: WeatherResult?, error: APIService.APIErrors?) in
                guard error == nil else {
                    self.currentWeatherOutput.value = WeatherOuput(ok: false)
                    return
                }
                
                if let data, let getWeather = data.getWeather {
                    self.manager.fetch(to: FetchWeatherDTO(type: .cityname(name: data.name))) { (city: [CityNameResult]?, e: APIService.APIErrors?) in
                        if e != nil {
                            returns.city = ""
                        }
                        
                        if let city, let ko = city.first?.local_names.ko {
                            returns.city = ko
                        } else {
                            returns.city = data.name
                        }
                        returns.currentTemps = data.main.calcTemps
                        returns.description = self.mapDescription(for: getWeather.id)
                        returns.icon = getWeather.icon
                        returns.additional = data.getAdditionalWeather
                        returns.additional["lat"] = self.currentCity.coord.lat
                        returns.additional["lon"] = self.currentCity.coord.lon
                        self.currentWeatherOutput.value = WeatherOuput(ok: true, error: nil, data: returns)
                    }
                    
                }
            }
        }
    }
    
    private func fetchForecast() {
        self.fetchCityInfo()
        
        var returns = ForecastDataReturnType(forcasts: [], tempAvgs: [], tempDays: [], tempIcons: [])
        DispatchQueue.global().async {
            self.manager.fetch(
                to: FetchWeatherDTO(type: .forecast(lat: self.currentCity.coord.lat, lon: self.currentCity.coord.lon))
            ) { (data: ForecastResult?, error: APIService.APIErrors?) in
                guard error == nil else {
                    self.forecastDataOutput.value = ForecastOutput(ok: false)
                    return
                }
                
                if let data {
                    returns.forcasts = data.tempForcasts
                    returns.tempAvgs = data.tempAvgs
                    returns.tempDays = data.tempDays
                    returns.tempIcons = data.tempIcons
                    self.forecastDataOutput.value = ForecastOutput(ok: true, data: returns)
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
}
