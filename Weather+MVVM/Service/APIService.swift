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
    
    enum RequestType {
        case current(id: Int)
        case forecast(lat: Double, lon: Double)
        case cityname(name: String)
    }
    
    enum APIErrors: String {
        case badRequest = "잘못된 요청입니다."
        case notFound = "요청 결과를 찾을 수 없습니다."
        case badResponse = "무언가 잘못되었어요 ㅠㅠ"
    }
    
    private func genEndPoint(to dto: FetchWeatherDTO) -> URL {
        var components = URLComponents()
        
        components.scheme = SCHEME
        components.host = HOST
        components.path = dto.path
        components.queryItems = dto.queryString
        
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
    
    typealias handler<T> = (T?, APIErrors?) -> ()
    
    func fetch<T: Decodable>(to dto: FetchWeatherDTO, handler: @escaping handler<T>) {
        let request = genRequest(genEndPoint(to: dto))
        self.fetchTask(for: request, handler: handler)
    }
    
    
    private func fetchTask<T: Decodable>(for request: URLRequest, handler: @escaping handler<T>) {
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
