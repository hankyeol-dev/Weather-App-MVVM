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
        vm?.loadInput.value = ()
        vm?.searchOutput.bind([], handler: { data in
            self.mv?.searchTable.reloadSections(IndexSet(integer: 0), with: .none)
        })
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
}

extension SearchCityViewController {
    @objc
    func searchCity() {
        guard let keyword = mv?.searchField.text else { return }
        vm?.searchInput.value = keyword
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
        cell.configureViewWithData(vm?.searchOutput.value[indexPath.row])
        cell.addTagToButton(vm?.searchOutput.value[indexPath.row].id)
        return cell
    }
    
}
