//
//  Extension+UILabel.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/13/24.
//

import UIKit

extension UILabel {
    func attrTextWithFontAndColor(for textList: [String], font: [UIFont], color: [UIColor]) {
        let target = text ?? ""
        let attrText = NSMutableAttributedString(string: target)
        textList.enumerated().forEach { (index, v) in
            attrText.addAttributes([.font: font[index] as Any, .foregroundColor: color[index] as Any], range: (target as NSString).range(of: v))
        }
        attributedText = attrText
    }
}
