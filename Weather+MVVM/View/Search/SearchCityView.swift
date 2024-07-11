//
//  SearchCityView.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import UIKit
import SnapKit

final class SearchCityView: BaseView {
    private let searchMenu = BaseItemWithTitle("원하는 도시를 검색해보세요.")
    let searchField = UITextField()
    let searchTable = UITableView()
    
    override func configureSubView() {
        super.configureSubView()
        self.addSubview(searchMenu)
        self.addSubview(searchTable)
        searchMenu.contentView.addSubview(searchField)
    }
    
    override func configureLayout() {
        super.configureLayout()
        searchMenu.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            
        }
        searchField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(searchMenu.contentView.safeAreaLayoutGuide)
            $0.top.equalTo(searchMenu.contentView.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(44)
            $0.bottom.equalTo(searchMenu.contentView.safeAreaLayoutGuide)
        }
        searchTable.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(searchMenu.snp.bottom).offset(8)
        }
    }
    
    override func configureView() {
        super.configureView()
        searchField.borderStyle = .none
        searchField.backgroundColor = .systemGray5
        searchField.layer.cornerRadius = 12
        searchField.tintColor = .black
        searchField.font = .systemFont(ofSize: 16)
        searchField.leftView = UIView(frame: CGRect(x: 8, y: 8, width: 12, height: 44))
        searchField.leftViewMode = .always
        
        searchTable.separatorStyle = .none
    }
}
