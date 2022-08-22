//
//  WeatherService.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func getCurrentWeather(coordinates: Coordinates) -> AnyPublisher<CurrentWeather, Error>
    func getForecast(coordinates: Coordinates) -> AnyPublisher<ForecastResponse, Error>
    func findCity(name: String) -> AnyPublisher<[City], Error>
}

class WeatherService: WeatherServiceProtocol {
    
    private let apiService = ApiService<WeatherEndpoint>()
    
    private lazy var decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    func getCurrentWeather(coordinates: Coordinates) -> AnyPublisher<CurrentWeather, Error> {
        
        apiService.request(from: .currentWeather(coordinates: coordinates))
            .decode(type: CurrentWeather.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func getForecast(coordinates: Coordinates) -> AnyPublisher<ForecastResponse, Error> {
        
        apiService.request(from: .forecast(coordinates: coordinates))
            .decode(type: ForecastResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func findCity(name: String) -> AnyPublisher<[City], Error> {
        
        apiService.request(from: .find(name: name))
            .decode(type: [City].self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
