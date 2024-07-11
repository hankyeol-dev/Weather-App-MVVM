//
//  BaseItemWithTitle.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import UIKit
import SnapKit

class BaseItemWithTitle: BaseView {
    private let titleLabel = UILabel()
    let contentView = UIView()
    
    convenience init(_ title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    override func configureSubView() {
        super.configureSubView()
        
        self.addSubview(titleLabel)
        self.addSubview(contentView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(24)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        self.layer.cornerRadius = 16
        self.backgroundColor = .systemGray6
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    func changeTitle(_ t: String) {
        self.titleLabel.text = t
    }
}
