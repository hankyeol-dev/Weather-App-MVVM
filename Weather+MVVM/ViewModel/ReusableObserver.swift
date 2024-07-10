//
//  ReusableObserver.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import Foundation

final class ReusableObserver<T> {
    private var handler: ((T) -> ())?
    
    var value: T {
        didSet {
            self.handler?(self.value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ value: T, handler: @escaping (T) -> ()) {
        handler(value)
        self.handler = handler
    }
}
