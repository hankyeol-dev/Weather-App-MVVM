//
//  LocationWeatherViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

final class LocationWeatherViewController: BaseViewController {
    
    private var vm: LocationWeatherViewModel?
    private var mv: LocationWeatherView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(vm: LocationWeatherViewModel, mv: LocationWeatherView) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.mv = mv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(title: "", leftBarItem: genLeftWithGoBack(.systemGray), rightBarItem: nil)
    }
}
