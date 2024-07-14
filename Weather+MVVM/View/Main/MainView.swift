//
//  MainView.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import UIKit
import MapKit

import Kingfisher
import SnapKit

final class MainView: BaseView {
    private let scroll = UIScrollView()
    private let back = UIView()
    
    private let header = BaseItemWithTitle("")
    private let icon = UIImageView()
    private lazy var curTemp = genLabel(for: "", font: .boldSystemFont(ofSize: 32))
    private lazy var curDescription = genLabel(for: "", font: .systemFont(ofSize: 16))
    private lazy var curTemps = genLabel(for: "", font: .systemFont(ofSize: 16))
    
    private let threeHourForecast = BaseItemWithTitle("3시간 간격 예보")
    lazy var collection = {
        var flow = UICollectionViewFlowLayout()
        let w = (getWindowWidth() - 56) / 5
        let h = w * 1.5
        flow.itemSize = CGSize(width: w, height: h)
        flow.minimumLineSpacing = 8
        flow.minimumInteritemSpacing = 0
        flow.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        flow.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: flow)
    }()
    
    private let fiveDaysForecast = BaseItemWithTitle("5일간의 일기 예보")
    let table = UITableView()
    
    private let mapItem = BaseItemWithTitle("위치")
    private let map = MKMapView()
    
    private let stackOne = UIStackView()
    private let stackTwo = UIStackView()
    
    override func configureSubView() {
        super.configureSubView()
        
        self.addSubview(scroll)
        scroll.addSubview(back)
        [header, threeHourForecast, fiveDaysForecast, mapItem, stackOne, stackTwo].forEach {
            back.addSubview($0)
        }
        [icon, curTemp, curDescription, curTemps].forEach {
            header.contentView.addSubview($0)
        }
        threeHourForecast.contentView.addSubview(collection)
        fiveDaysForecast.contentView.addSubview(table)
        mapItem.contentView.addSubview(map)
    }
    
    override func configureLayout() {
        super.configureLayout()
        scroll.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        back.snp.makeConstraints {
            $0.width.equalTo(scroll.snp.width)
            $0.verticalEdges.equalTo(scroll)
        }
        
        configureHeaderLayout()
        configurethreeHourForecastLayout()
        configureFiveDaysLayout()
        configureMapLayout()
        configureStackLayout()
    }
    
    override func configureView() {
        super.configureView()
        
        scroll.backgroundColor = .clear
        back.backgroundColor = .clear
        
        configureHeaderView()
        configureThreeHourForecastView()
        configureFiveDaysForecastView()
        configureMapView()
        configureStackView()
    }
    
    
}

extension MainView {
    func configureViewWithData(_ data: WeatherDataReturnType) {
        let temps = data.currentTemps
        DispatchQueue.main.async {
            self.header.changeTitle(data.city + "의 현재 날씨")
            self.icon.kf.setImage(with: URL(string: ICON_URL + data.icon + "@2x.png"))
            self.curTemp.text = "\(temps[0])℃"
            self.curDescription.text = data.description
            self.curTemps.text = "최고 온도: \(temps[2])℃ | 최저 온도: \(temps[1])℃"
            
            if let lat = data.additional["lat"], let lon = data.additional["lon"] {
                let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = data.city
                self.map.setRegion(MKCoordinateRegion(center: center, latitudinalMeters: 50, longitudinalMeters: 50), animated: false)
                self.map.addAnnotation(annotation)
            }
            print(data.additional)
            data.additional.enumerated().forEach { (idx, value) in
                switch value.key {
                case "기압":
                    self.genStackItem(for: self.stackOne, as: value.key, text: "\(value.value) hpa")
                case "습도":
                    self.genStackItem(for: self.stackOne, as: value.key, text: "\(value.value)%")
                case "구름":
                    self.genStackItem(for: self.stackTwo, as: value.key, text: "\(value.value)%")
                case "바람":
                    self.genStackItem(for: self.stackTwo, as: value.key, text: "\(value.value) m/s")
                default:
                    break;
                }
            }
        }
    }
    private func genLabel(for text: String, font: UIFont) -> UILabel {
        let v = UILabel()
        
        v.text = text
        v.textAlignment = .center
        v.font = font
        v.textColor = .black
        
        return v
    }
    private func getWindowWidth() -> CGFloat {
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        return window.screen.bounds.width
    }
    
    private func configureHeaderLayout() {
        header.snp.makeConstraints {
            $0.top.equalTo(back.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
        }
        
        icon.snp.makeConstraints {
            $0.top.equalTo(header.contentView.safeAreaLayoutGuide).inset(8)
            $0.centerX.equalTo(header.contentView.snp.centerX)
            $0.size.equalTo(50)
        }
        
        curTemp.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(4)
            $0.centerX.equalTo(header.contentView.snp.centerX)
            $0.height.equalTo(48)
        }
        
        curDescription.snp.makeConstraints {
            $0.top.equalTo(curTemp.snp.bottom)
            $0.centerX.equalTo(header.contentView.snp.centerX)
            $0.height.equalTo(28)
        }
        
        curTemps.snp.makeConstraints {
            $0.top.equalTo(curDescription.snp.bottom)
            $0.centerX.equalTo(header.contentView.snp.centerX)
            $0.height.equalTo(28)
            $0.bottom.equalTo(header.contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    private func configureHeaderView() {
        header.backgroundColor = .systemGray6
        header.layer.cornerRadius = 16
        
        icon.contentMode = .scaleAspectFit
    }

}

extension MainView {
    private func configurethreeHourForecastLayout() {
        threeHourForecast.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
        }
        collection.snp.makeConstraints {
            $0.horizontalEdges.equalTo(threeHourForecast.contentView.safeAreaLayoutGuide)
            $0.verticalEdges.equalTo(threeHourForecast.contentView.safeAreaLayoutGuide)
            $0.height.equalTo(((getWindowWidth() - 56) / 5) * 2)
        }
    }
    private func configureThreeHourForecastView() {
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
    }
}

extension MainView {
    private func configureFiveDaysLayout() {
        fiveDaysForecast.snp.makeConstraints {
            $0.top.equalTo(threeHourForecast.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
        }
        table.snp.makeConstraints {
            $0.edges.equalTo(fiveDaysForecast.contentView.safeAreaLayoutGuide)
            $0.center.equalTo(fiveDaysForecast.contentView.snp.center)
            $0.height.equalTo(370)
        }
    }
    private func configureFiveDaysForecastView() {
        table.backgroundColor = .systemGray6
        table.showsVerticalScrollIndicator = false
    }
}

extension MainView {
    private func configureMapLayout() {
        mapItem.snp.makeConstraints {
            $0.top.equalTo(fiveDaysForecast.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
        }
        map.snp.makeConstraints {
            $0.top.equalTo(mapItem.contentView.safeAreaLayoutGuide).inset(8)
            $0.bottom.horizontalEdges.equalTo(mapItem.contentView.safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
    }
    
    private func configureMapView() {
        map.layer.cornerRadius = 8
    }
}

extension MainView {
    private func configureStackLayout() {
        stackOne.snp.makeConstraints {
            $0.top.equalTo(mapItem.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
        stackTwo.snp.makeConstraints {
            $0.top.equalTo(stackOne.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalTo(back.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
    }
    
    private func configureStackView() {
        [stackOne, stackTwo].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
    }
    
    private func genStackItem(for target: UIStackView, as title: String, text: String) {
        let item = BaseItemWithTitle(title)
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .systemGray
        
        target.addArrangedSubview(item)
        item.contentView.addSubview(label)
        
        item.snp.makeConstraints {
            $0.verticalEdges.equalTo(target.safeAreaLayoutGuide).inset(4)
            $0.centerY.equalTo(target.snp.centerY)
        }
        label.snp.makeConstraints {
            $0.center.equalTo(item.contentView.snp.center).inset(4)
        }
    }
}
