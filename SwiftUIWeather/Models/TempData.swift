//
//  TempData.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

struct TempData: Decodable, Hashable {
    let temp: Double
    let tempMax: Double
    let tempMin: Double
}
