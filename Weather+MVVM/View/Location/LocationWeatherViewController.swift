//
//  LocationWeatherViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit
import MapKit

final class LocationWeatherViewController: BaseViewController {    
    private weak var vm: LocationWeatherViewModel?
    weak var mv: LocationWeatherView?
    var sender: ((CLLocationCoordinate2D) -> ())?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(vm: LocationWeatherViewModel, mv: LocationWeatherView) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.mv = mv
    }
    
    override func loadView() {
        self.view = mv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vm {
            mv?.configureViewWithData(lat: vm.getCurrentCityInfo().coord.lat, lon: vm.getCurrentCityInfo().coord.lon)
        }
    
        mv?.map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchMap)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(title: "", leftBarItem: genLeftWithGoBack(.systemGray), rightBarItem: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc
    private func touchMap(_ sender: UITapGestureRecognizer) {
        if let mv {
            let location = sender.location(in: mv.map)
            let point = mv.map.convert(location, toCoordinateFrom: mv.map)
            
            if sender.state == .ended {
                mv.searchLocation(point: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
                self.showAlert(location: point)
            }
        }
    }
    
    
    private func showAlert(location: CLLocationCoordinate2D) {
        let alert = UIAlertController()
        alert.title = "이 위치의 날씨를 조회할까요?"
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.sender?(location)
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
