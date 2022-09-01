//
//  WeatherDescription.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

struct WeatherDescription: Decodable, Hashable {
    let main: WeatherStatus
    let description: String
}
