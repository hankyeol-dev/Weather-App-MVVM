//
//  SearchCityViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

final class SearchCityViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(title: "", leftBarItem: genLeftWithGoBack(.systemGray), rightBarItem: nil)
    }
}
