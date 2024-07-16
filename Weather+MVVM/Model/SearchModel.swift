//
//  SearchModel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation
import SwiftData


@Model
final class SearchModel {
    @Attribute(.unique) var id: Int // city id
    var name: String
    var lat: Double
    var lon: Double
    let createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init(id: Int, name: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}

final class SearchRepository {
    private var container: ModelContainer?
    private var context: ModelContext?
    
    enum RepositoryErrors: String, Error {
        case notFound = "일치하는 데이터를 찾지 못했습니다."
        case requestError = "데이터 조회 요청에 실패했습니다."
    }
    
    
    init() {
        do {
            container = try ModelContainer(for: SearchModel.self)
            
            if let container {
                context = ModelContext(container)
            }
            
        } catch {
            fatalError("SwiftData 구성에 뭔가 문제가 발생했어요 :(")
        }
    }
    
    func addSearch(by search: SearchModel) {
        if let context {
            context.insert(search)
        }
    }
    
    func readSearch(dataHandler: @escaping ([SearchModel]?, RepositoryErrors?) -> () ) {
        let descriptor = FetchDescriptor<SearchModel>(sortBy: [SortDescriptor<SearchModel>(\.createdAt, order: .reverse)])
        
        if let context {
            do {
                let data = try context.fetch(descriptor)
                dataHandler(data, nil)
            } catch {
                dataHandler(nil, .requestError)
            }
        }
    }
    
    func readSearchById(by cityId: Int, dataHandler: @escaping (SearchModel?, RepositoryErrors?) -> ()) {
        let descriptor = FetchDescriptor<SearchModel>(predicate: #Predicate { $0.id == cityId })
        
        if let context {
            do {
                let data = try context.fetch(descriptor)
                if data.count != 0 {
                    dataHandler(data.first, nil)
                } else {
                    dataHandler(nil, .notFound)
                }
            } catch {
                dataHandler(nil, .requestError)
            }
        }
    }
    
    func deleteSearch(for search: SearchModel) {
        if let context {
            context.delete(search)
        }
    }
    
    func deleteAll() {
        if let context {
            do {
                try context.delete(model: SearchModel.self)
            } catch {
                print(error)
            }
        }
    }
}
