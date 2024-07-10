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
    
    func addSearch(_ search: SearchModel) {
        if let context {
            context.insert(search)
        }
    }
    
    func readSearch(dataHandler: @escaping ([SearchModel]?, Error?) -> () ) {
        let descriptor = FetchDescriptor<SearchModel>(sortBy: [SortDescriptor<SearchModel>(\.createdAt, order: .reverse)])
        
        if let context {
            do {
                let data = try context.fetch(descriptor)
                dataHandler(data, nil)
            } catch {
                dataHandler(nil, error)
            }
        }
    }
}
