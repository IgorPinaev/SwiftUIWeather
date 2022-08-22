//
//  CityViewModel.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine

final class CityViewModel: ObservableObject {
    
    @Published private (set) var weather: CurrentWeather?
    @Published private (set) var hourlyList: [Forecast]?
    @Published private (set) var dailyList: [DailyForecast]?
    @Published private (set) var error: Error?
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    func getCurrentWeather(coordinates: Coordinates) {
        Publishers.CombineLatest(
            weatherService.getCurrentWeather(coordinates: coordinates),
            weatherService.getForecast(coordinates: coordinates)
        )
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case let .failure(error):
                self.error = error
            case .finished:
                break
            }
        } receiveValue: { [weak self] weather, forecast in
            self?.weather = weather
            self?.hourlyList = Array(forecast.list.prefix(8))
            self?.dailyList = self?.configureDailyData(forecastList: forecast.list)
        }
        .store(in: &bag)
    }
}

private extension CityViewModel {
    
    func configureDailyData(forecastList: [Forecast]?) -> [DailyForecast] {
        guard let forecastList = forecastList, let firstElement = forecastList.first else { return [] }

        var dailyList = [DailyForecast]()
        
        var max = firstElement.main.tempMax
        var min = firstElement.main.tempMin
        var date = firstElement.dt.day
        
        forecastList
            .enumerated()
            .forEach { forecast in
                let element = forecast.element
                let isDateEqual = element.dt.day == date
                let isLastElement = forecast.offset == forecastList.count - 1
                
                if isDateEqual || isLastElement {
                    if element.main.tempMax > max {
                        max = element.main.tempMax
                    }
                    
                    if element.main.tempMin < min {
                        min = element.main.tempMin
                    }
                }
                
                if !isDateEqual || isLastElement {
                    dailyList.append(.init(
                        maxTemp: max,
                        minTemp: min,
                        day: date
                    ))
                    max = element.main.tempMax
                    min = element.main.tempMin
                    date = element.dt.day
                }
            }
        
        return dailyList
    }
}
