//
//  BaseView.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

class BaseView: UIView {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        configureLayout()
        configureView()
    }
    
    
    func configureSubView(){}
    func configureLayout(){}
    func configureView(){}
}

extension BaseView {
    func configureViewWithData<T>(_ data: T) { }
    func addAction<T: UIControl>(_ component: T, target: Any?, selector: Selector, event: UIControl.Event) {
        component.addTarget(target, action: selector, for: event)
    }
}

