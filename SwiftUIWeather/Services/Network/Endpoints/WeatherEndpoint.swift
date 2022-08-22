//
//  WeatherEndpoint.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather(coordinates: Coordinates)
    case forecast(coordinates: Coordinates)
    case find(name: String)
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
        case .find:
            return "/geo/1.0/direct"
        }
    }
    
    var params: [String : String] {
        var params = ["appid": "e382f69da8950542f476171cc68678de", "lang": Locale.current.languageCode ?? "en", "units": "metric"]
        switch self {
        case let .currentWeather(coordinates),
             let .forecast(coordinates):
            params["lat"] = coordinates.lat.description
            params["lon"] = coordinates.lon.description
        case let .find(name):
            params["q"] = name
            params["limit"] = "0"
        }
        return params
    }
}
