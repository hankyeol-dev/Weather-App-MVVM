//
//  MainViewModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

final class MainViewModel {
    private let repository = SearchRepository()
    private let apiManager = APIService.manager
    
    /**
     MainView에서 필요한 데이터 정리
     1. 현재 정보
        1. 도시 이름
            - 검색한 결과가 있다면? > 가장 최근에 검색한 결과를 보여준다.
            - 검색한 결과가 없다면? > 서울의 결과를 보여준다. (최초)
        2. 현재 온도
        3. 최고 온도, 최저온도
        4. 아이콘
     2. 3시간 간격 일기 예보
        - 최대 10개 까지만 보여주도록
     3. 5일간 일기 예보
     */
    private var currentCityId: Int = 0
    var viewDidInput = ValueObserver<Void?>(nil)
    var currentDataOuput = ValueObserver<CurrentWeatherOutput?>(nil)
    
    init() {
        self.viewDidInput.bind(nil) { value in
            guard value != nil else { return }
            self.fetchCurrentWeather()
        }
    }
    
    private func fetchCurrentWeather() {
        // 1. 도시 정보를 먼저 DB에서 조회해서 가져오고
        repository.readSearch { (search, error) in
            if let error {
                print(error)
            }
            
            if let search, search.count != 0, let city = search.first {
                self.currentCityId = city.id
            } else {
                self.currentCityId = SEOUL_CITY_ID
            }
        }
        
        // 2. fetch
        DispatchQueue.global().async {
            self.apiManager.fetch(to: FetchWeatherDTO(type: .current(id: self.currentCityId))) { (data: WeatherResult?, error: APIService.APIErrors?) in
                if let error {
                    print(error.rawValue)
                    return
                }
                
                if let data {
                    self.currentDataOuput.value = CurrentWeatherOutput(city: data.name, calcTemps: data.main.calcTemps, icon: data.getWeather?.icon ?? "")
                }
            }
        }
    }
}
