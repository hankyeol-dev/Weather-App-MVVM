//
//  ForecastOutput.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/12/24.
//

import Foundation

struct ForecastDataReturnType {
    var forcasts: [Forecast]
    var tempAvgs: [[Double]]
    var tempDays: [String]
    var tempIcons: [String]
}

struct ForecastOutput {
    var ok: Bool
    var error: String?
    var data: ForecastDataReturnType?
}
