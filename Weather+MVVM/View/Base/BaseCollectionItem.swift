//
//  BaseCollectionItem.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

class BaseCollectionItem: UICollectionViewCell {
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
    
    /**
     뷰에 자식 뷰를 추가하는 메서드
     - view.addSubview(someview)
     */
    func configureSubView(){}
    
    /**
     Snapkit 라이브러리를 활용하여 뷰 객체의 레이아웃을 잡는 메서드
     - someview.snp.makeConstraint { }
     */
    func configureLayout(){}
    
    /**
     뷰 객체의 UI 코드를 작성하고, 데이터 맵핑을 진행
     - someview.text = "someview"
     - someview.textColor = .red
     */
    func configureView(){}
}
