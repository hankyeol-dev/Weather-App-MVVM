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
    
    /**
     MainView에서 필요한 데이터 정리
     2. 3시간 간격 일기 예보
        - 최대 10개 까지만 보여주도록
     3. 5일간 일기 예보
     */
    private var currentCityId: Int = 0
    var viewDidInput = ValueObserver<Void?>(nil)
    var currentWeatherOutput = ValueObserver<WeatherOuput?>(nil)
//    var forecastDataOutput = ValueObserver
    
    init(repository: SearchRepository) {
        self.repository = repository
        self.viewDidInput.bind(nil) { value in
            guard value != nil else { return }
            self.fetchCurrentWeather()
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
        fetchSearch()
        
        // 2. fetch
        DispatchQueue.global().async {
            var returns = WeatherDataReturnType(city: "", currentTemps: [], description: "", icon: "")
            self.manager.fetch(to: FetchWeatherDTO(type: .current(id: self.currentCityId))) { (data: WeatherResult?, error: APIService.APIErrors?) in
                if let error {
                    self.currentWeatherOutput.value = WeatherOuput(ok: false, error: error.rawValue, data: nil)
                    return
                }
                
                if let data, let getWeather = data.getWeather {
                    self.manager.fetch(to: FetchWeatherDTO(type: .cityname(name: data.name))) { (city: [CityNameResult]?, e: APIService.APIErrors?) in
                        if let e {
                            returns.city = ""
                        }
                        
                        if let city, let ko = city.first?.local_names.ko {
                            returns.city = ko
                            returns.currentTemps = data.main.calcTemps
                            returns.description = self.mapDescription(for: getWeather.id)
                            returns.icon = getWeather.icon
                            self.currentWeatherOutput.value = WeatherOuput(ok: true, error: nil, data: returns)
                        }
                    }
                    
                }
            }
        }
    }
    
    private func fetchSearch() {
        repository?.readSearch { search, error in
            if let error { print(error) }
            if let search, search.count != 0, let city = search.first {
                self.currentCityId = city.id
            } else {
                self.currentCityId = SEOUL_CITY_ID
            }
        }
    }
}
