//
//  WeatherEndpoint.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather
    case forecast
}

extension WeatherEndpoint: EndpointProtocol {
    
    var host: String {
        "api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        }
    }
    
    var params: [String : String] {
        var params = ["appid": "e382f69da8950542f476171cc68678de", "lang": "ru", "units": "metric"]
        switch self {
        case .currentWeather, .forecast:
            params["q"] = "Moscow"
        }
        return params
    }
}
