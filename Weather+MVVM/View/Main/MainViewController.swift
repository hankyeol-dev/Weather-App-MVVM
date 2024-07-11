//
//  MainViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

class MainViewController: BaseViewController {
    private var vm: MainViewModel?
    private let mainView = MainView()
    
    init(vm: MainViewModel) {
        self.vm = vm
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
        configureData()
    }

    func configureData() {
        vm?.viewDidInput.value = ()
        vm?.currentWeatherOutput.bind(nil, handler: { output in
            if let data = output?.data {
                self.mainView.configureViewWithData(data)
            }
        })
    }
}

extension MainViewController {
    func configureToolBar() {
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
        goSomeVC(vc: LocationWeatherViewController()) { _ in }
    }
    
    @objc
    func goSearchVC() {
        goSomeVC(vc: SearchCityViewController()) { _ in }
    }
}
