//
//  ForecastResponse.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [Forecast]
}

struct Forecast: Decodable, Hashable {
    let dt: Date
    let main: TempData
    let weather: [WeatherDescription]
}
