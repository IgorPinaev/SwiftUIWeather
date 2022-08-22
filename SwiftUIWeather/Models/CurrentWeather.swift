//
//  CurrentWeather.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

struct CurrentWeather: Decodable {
    let name: String
    let coord: Coordinates
    let main: TempData
    let weather: [WeatherDescription]
}
