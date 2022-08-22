//
//  WeatherService.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func getCurrentWeather() -> AnyPublisher<CurrentWeather, Error>
    func getForecast() -> AnyPublisher<ForecastResponse, Error>
}

class WeatherService: WeatherServiceProtocol {
    
    private let apiService = ApiService<WeatherEndpoint>()
    
    private lazy var decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    func getCurrentWeather() -> AnyPublisher<CurrentWeather, Error> {
        
        apiService.request(from: .currentWeather)
            .decode(type: CurrentWeather.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func getForecast() -> AnyPublisher<ForecastResponse, Error> {
        
        apiService.request(from: .forecast)
            .decode(type: ForecastResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
