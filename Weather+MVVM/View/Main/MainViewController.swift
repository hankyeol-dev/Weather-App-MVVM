//
//  MainViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit
import MapKit

final class MainViewController: BaseViewController {
    private weak var vm: MainViewModel?
    private weak var mainView: MainView?
    
    init(vm: MainViewModel, mv: MainView) {
        self.vm = vm
        self.mainView = mv
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToolBar()
        configureCollection()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(title: "현재 날씨", leftBarItem: nil, rightBarItem: nil)
        configureData()
    }

    func configureData() {
        vm?.viewDidInput.value = ()
        vm?.currentWeatherOutput.bind(nil, handler: { [weak self] output in
            DispatchQueue.main.async {
                if let data = output?.data {
                    self?.mainView?.configureViewWithData(data)
                }
            }
        })
        vm?.forecastDataOutput.bind(nil, handler: { [weak self] output in
            DispatchQueue.main.async {
                if output?.ok != nil {
                    self?.mainView?.collection.reloadData()
                    self?.mainView?.table.reloadSections(IndexSet(integer: 0), with: .none)
                }
            }
        })
    }
}

extension MainViewController {
    private func configureToolBar() {
        navigationController?.isToolbarHidden = false
        
        let left = UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .plain, target: self, action: #selector(goLocationVC))
        left.tintColor = .systemGray
        
        let right = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(goSearchVC))
        right.tintColor = .systemGray
        
        let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
                
        setToolbarItems([left, flexible, right], animated: true)
    }
    
    @objc
    func goLocationVC() {
        goSomeVC(vc: LocationWeatherViewController(
            vm: LocationWeatherViewModel(repository: SearchRepository(), apiManager: APIService.manager),
            mv: LocationWeatherView() )
        ) { vc in
            vc.sender = { [weak self] location in
                self?.vm?.updateCityInput.value = CountryCoord(lat: location.latitude, lon: location.longitude)
            }
        }
    }
    
    @objc
    func goSearchVC() {
        goSomeVC(
            vc: SearchCityViewController(vm: SearchViewModel(repository: SearchRepository(), manager: APIService.manager), mv: SearchCityView())
        ) { _ in }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollection() {
        mainView?.collection.delegate = self
        mainView?.collection.dataSource = self
        mainView?.collection.register(MainForecastItem.self, forCellWithReuseIdentifier: MainForecastItem.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm else { return 0 }
        guard let data = vm.forecastDataOutput.value?.data else { return 0 }
        return data.forcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm else { return  UICollectionViewCell() }
        guard let data = vm.forecastDataOutput.value?.data else { return UICollectionViewCell() }
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: MainForecastItem.id, for: indexPath) as! MainForecastItem
        item.configureCollectionWithData(data.forcasts[indexPath.row])
        return item
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTable() {
        guard let table = mainView?.table else { return }
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 60
        
        table.separatorColor = .systemGray4
        table.separatorInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        MainForecastCell.register(tableView: table)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm else { return 0 }
        guard let data = vm.forecastDataOutput.value?.data else { return 0 }
        return data.tempDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let table = mainView?.table else { return UITableViewCell() }
        guard let vm else { return UITableViewCell() }
        guard let data = vm.forecastDataOutput.value?.data else { return UITableViewCell() }
        
        let cell = MainForecastCell.dequeueReusableCell(tableView: table)
        cell.configureViewWithData(tempAvgs: [data.tempAvgs[0][indexPath.row], data.tempAvgs[1][indexPath.row]], tempDays: data.tempDays[indexPath.row], tempIcons: data.tempIcons[indexPath.row])
        return cell
    }
}
