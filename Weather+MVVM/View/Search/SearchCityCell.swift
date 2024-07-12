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
    private let button = UIButton()
    
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
    /**
     해야 하는 것
     1. CellReturnType에 'isSelected' 값 반영 필요 -> 이미 추가된 버튼은 ui 변경
     2. 추가 버튼 터치시 ViewModel에서 DB에 저장하는 로직 추가
     3. 이미 추가된 항목에 추가 버튼 한 번 더 터치시 DB에 삭제하는 로직 추가
     */
    
    func addTagToButton(_ tag: Int?) {
        guard let tag else { return }
        button.tag = tag
    }
    
    func addActionToButton(isSelected: Bool, target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
    
    private func isSelected() {
        button.configuration?.title = "추가됨"
        button.configuration?.baseForegroundColor = .systemGray6
        button.configuration?.baseBackgroundColor = .systemGray
    }
    
    private func notSelected() {
        button.configuration?.title = "추가"
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = .systemGreen
    }
}
