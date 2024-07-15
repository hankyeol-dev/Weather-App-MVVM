//
//  SearchCityViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

final class SearchCityViewController: BaseViewController {
    private var vm: SearchViewModel?
    private var mv: SearchCityView?
    
    init(vm: SearchViewModel, mv: SearchCityView) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.mv = mv
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(title: "도시 검색", leftBarItem: genLeftWithGoBack(.systemGray), rightBarItem: nil)
    }
    
    override func configureAction() {
        super.configureAction()
        
        guard let mv else { return }
        mv.addAction(mv.searchField, target: self, selector: #selector(searchCity), event: .editingChanged)
    }
    
    private func configureData() {
        vm?.loadInput.value = ()
        vm?.searchOutput.bind([], handler: { output in
            if output.count != 0 {
                self.mv?.searchTable.reloadData()
            }
        })
    }
}

extension SearchCityViewController {
    @objc
    func searchCity() {
        guard let keyword = mv?.searchField.text else { return }
        vm?.searchInput.value = keyword
    }
    
    @objc
    func addCity(_ sender: UIButton) {
        vm?.addButtonInput.value = sender.tag
    }
    
    @objc
    func deleteCity(_ sender: UIButton) {
        vm?.deleteButtonInput.value = sender.tag
    }
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTable() {
        guard let mv else { return }
        let table = mv.searchTable
        
        SearchCityCell.register(tableView: table)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm else { return 0 }
        return vm.searchOutput.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchCityCell.dequeueReusableCell(tableView: tableView)
        let cellData = vm?.searchOutput.value[indexPath.row]
        
        if let cellData {
            cell.configureViewWithData(cellData)
            cell.button.tag = cellData.country.id
            cell.button.addTarget(self, action: cellData.isSelected ? #selector(deleteCity) : #selector(addCity), for: .touchUpInside)
        }
        
        return cell
    }
    
}
