//
//  Double+ConvertToString.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

extension Double {
    
    var toTempString: String {
        return String(format: "%.1f", self) + "°"
    }
}
