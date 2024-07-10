//
//  APIService.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

final class APIService {
    static let manager = APIService()
    
    private init() {}
    
    enum RequestType: String {
        case current = "weather"
        case forecast = "forecast"
        case cityname
    }
    
    enum APIErrors: String {
        case badRequest = "잘못된 요청입니다."
        case notFound = "요청 결과를 찾을 수 없습니다."
        case badResponse = "무언가 잘못되었어요 ㅠㅠ"
    }
    
    private func genEndPoint(for requestType: RequestType, lat: Double, lon: Double) -> URL {
        var components = URLComponents()
        
        components.scheme = SCHEME
        components.host = HOST
        components.path = PATH_MAIN + requestType.rawValue
        components.queryItems = [
            URLQueryItem(name: "lang", value: "kr"),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: APIKEY)
        ]
        
        return components.url!
    }
    
    private func genEndPoint(for requestType: RequestType, cityName: String) -> URL {
        var components = URLComponents()
        
        components.scheme = SCHEME
        components.host = HOST
        components.path = PATH_CITY
        components.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: APIKEY)
        ]
        
        return components.url!
    }
    
    private func genRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        return request
    }
    
    func loadLocalJSON() -> [Country]? {
        guard let location = Bundle.main.url(forResource: JSON_FILE_NAME, withExtension: JSON_FILE_EXTENSION) else {
            return nil
        }
        
        do {
            let json = try Data(contentsOf: location)
            guard let data = try? JSONDecoder().decode([Country].self, from: json) else {
                return nil
            }
            
            return data
            
        } catch {
            return nil
        }
    }
    
    func fetch<T: Decodable>(_ requestType: RequestType, cityName: String, handler: @escaping(T?, APIErrors?) -> ()) {
        let request = genRequest(genEndPoint(for: requestType, cityName: cityName))
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                handler(nil, .badRequest)
                return
            }
            
            guard let data else {
                handler(nil, .notFound)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                handler(result, nil)
            } catch {
                print(error)
                handler(nil, .badResponse)
            }
        }
        
        task.resume()
    }
    
    func fetch<T: Decodable>(_ requestType: RequestType, lat: Double, lon: Double, handler: @escaping(T?, APIErrors?) -> ()) {
        let request = genRequest(genEndPoint(for: requestType, lat: lat, lon: lon))
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard error == nil else {
                handler(nil, .badRequest)
                return
            }
            
            guard let data else {
                handler(nil, .notFound)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                handler(result, nil)
            } catch {
                print(error)
                handler(nil, .badResponse)
            }
        }
        
        task.resume()
    }
}
