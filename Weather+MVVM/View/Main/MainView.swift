//
//  MainView.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/11/24.
//

import UIKit

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
    
    override func configureSubView() {
        self.addSubview(scroll)
        scroll.addSubview(back)
        [header].forEach {
            back.addSubview($0)
        }
        [icon, curTemp, curDescription, curTemps].forEach {
            header.contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        scroll.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        back.snp.makeConstraints {
            $0.width.equalTo(scroll.snp.width)
            $0.verticalEdges.equalTo(scroll)
        }
        
        header.snp.makeConstraints {
            $0.width.equalTo(back.snp.width)
        }

        configureHeaderLayout()
    }
    
    override func configureView() {
        scroll.backgroundColor = .clear
        back.backgroundColor = .clear
        
        header.backgroundColor = .systemGray6
        header.layer.cornerRadius = 16
        
        icon.contentMode = .scaleAspectFit
        
    }
    
    
    func configureViewWithData(_ data: WeatherDataReturnType) {
        let temps = data.currentTemps
        DispatchQueue.main.async {
            self.header.changeTitle(data.city + "의 현재 날씨")
            self.icon.kf.setImage(with: URL(string: ICON_URL + data.icon + "@2x.png"))
            self.curTemp.text = "\(temps[0])℃"
            self.curDescription.text = data.description
            self.curTemps.text = "최고 온도: \(temps[2])℃ | 최저 온도: \(temps[1])℃"
        }
    }
}

extension MainView {
    private func genLabel(for text: String, font: UIFont) -> UILabel {
        let v = UILabel()
        
        v.text = text
        v.textAlignment = .center
        v.font = font
        v.textColor = .black
        
        return v
    }
    
    private func configureHeaderLayout() {
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
}
