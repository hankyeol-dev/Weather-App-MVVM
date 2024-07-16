//
//  MainForecastCell.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MainForecastCell: BaseTableCell {
    private let back = UIView()
    private let day = UILabel()
    private let icon = UIImageView()
    private let temp = UILabel()
    
    override func configureSubView() {
        super.configureSubView()
        
        contentView.addSubview(back)
        [day, icon, temp].forEach {
            back.addSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        back.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        day.snp.makeConstraints {
            $0.centerY.equalTo(back.snp.centerY)
            $0.leading.equalTo(back.safeAreaLayoutGuide).inset(16)
            $0.verticalEdges.equalTo(back.safeAreaLayoutGuide).inset(8)
        }
        
        icon.snp.makeConstraints {
            $0.centerY.equalTo(back.snp.centerY)
            $0.size.equalTo(40)
            $0.trailing.equalTo(temp.snp.leading).offset(-8)
        }
        
        temp.snp.makeConstraints {
            $0.centerY.equalTo(back.snp.centerY)
            $0.trailing.equalTo(back.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(120)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .systemGray6
        back.backgroundColor = .systemGray6
        day.font = .systemFont(ofSize: 16)
        temp.textAlignment = .right
        temp.font = .systemFont(ofSize: 16)
    }
    
    func configureViewWithData(tempAvgs: [Double], tempDays: String, tempIcons: String) {
        
        DispatchQueue.main.async {
            self.day.text = tempDays
            self.icon.kf.setImage(with: URL(string: ICON_URL + tempIcons + "@2x.png"))
            self.temp.text = "\(tempAvgs[0]) / \(tempAvgs[1])"
            
            let minText = self.temp.text?.components(separatedBy: " / ").first ?? ""
            let maxText = self.temp.text?.components(separatedBy: " / ").last ?? ""
            self.temp.attrTextWithFontAndColor(for: [minText, maxText], font: [.systemFont(ofSize: 14), .boldSystemFont(ofSize: 16)], color: [.systemBlue.withAlphaComponent(0.6), .systemRed])
        }
    }
}
