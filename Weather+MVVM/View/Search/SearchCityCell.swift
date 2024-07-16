//
//  SearchCityCell.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import UIKit
import SnapKit

final class SearchCityCell: BaseTableCell {
    private let back = UIView()
    private let label = UILabel()
    let button = UIButton()
    
    override func configureSubView() {
        super.configureSubView()
        
        contentView.addSubview(back)
        back.addSubview(label)
        back.addSubview(button)
    }
    
    override func configureLayout() {
        back.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        label.snp.makeConstraints {
            $0.centerY.equalTo(back.snp.centerY)
            $0.leading.equalTo(back.safeAreaLayoutGuide).inset(16)
            $0.verticalEdges.equalTo(back.safeAreaLayoutGuide).inset(8)
            $0.trailing.equalTo(button.snp.leading).offset(-8)
        }
        button.snp.makeConstraints {
            $0.centerY.equalTo(back.snp.centerY)
            $0.trailing.equalTo(back.safeAreaLayoutGuide).inset(8)
            $0.verticalEdges.equalTo(back.safeAreaLayoutGuide).inset(8)
            $0.width.equalTo(72)
        }
    }
    
    override func configureView() {
        back.backgroundColor = .systemGray6
        back.layer.cornerRadius = 8
        
        label.font = .systemFont(ofSize: 18)
        
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.titleAlignment = .center
    }
    
    func configureViewWithData(_ data: SearchCityOutput?) {
        guard let data else { return }
        self.label.text = data.country.name

        if data.isSelected {
            self.isSelected()
        } else {
            self.notSelected()
        }
    }
}

extension SearchCityCell {
    func isSelected() {
        button.configuration?.title = "추가됨"
        button.configuration?.baseForegroundColor = .systemGray6
        button.configuration?.baseBackgroundColor = .systemGray
    }
    
    func notSelected() {
        button.configuration?.title = "추가"
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = .systemGreen
    }
}
