//
//  MainForecastItem.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MainForecastItem: BaseCollectionItem {
    static let id = "MainForecastItem"
    
    private let time = UILabel()
    private let icon = UIImageView()
    private let temp = UILabel()
    
    override func configureSubView() {
        super.configureSubView()
        [time, icon, temp].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        time.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        icon.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.top.equalTo(time.snp.bottom).offset(8)
            $0.size.equalTo(40)
        }
        temp.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.top.equalTo(icon.snp.bottom).offset(12)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
    
    override func configureView() {
        super.configureView()
        [time, temp].forEach {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        icon.contentMode = .scaleAspectFit
    }
    
    func configureCollectionWithData(_ data: Forecast) {
        let timeString = String(data.dt_txt.split(separator: " ")[1].split(separator: ":")[0] + "시")
        guard let getWeather = data.getWeather else { return }
        DispatchQueue.main.async {
            self.time.text = timeString
            self.icon.kf.setImage(with: URL(string: ICON_URL + getWeather.icon + "@2x.png"))
            self.temp.text = "\(data.main.calcTemps[0])"
        }
        
    }
}
