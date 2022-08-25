//
//  CityViewModel.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine

final class CityViewModel: ObservableObject {
    
    var isNeedUpdate = PassthroughSubject<Void, Never>()
    
    @Published private (set) var weather: CurrentWeather?
    @Published private (set) var hourlyList: [Forecast]?
    @Published private (set) var dailyList: [DailyForecast]?
    @Published private (set) var error: Error?
    
    private let coordinates: Coordinates
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    init(coordinates: Coordinates) {
        self.coordinates = coordinates
        configurePublishers()
    }
    
    func saveCity(city: City) {
        CityEntity.save(from: city)
        CoreDataService.shared.saveContext()
    }
}

private extension CityViewModel {
    
    func configurePublishers() {
        isNeedUpdate
            .flatMap { [weatherService, coordinates] _ in
                Publishers.CombineLatest(
                    weatherService.getCurrentWeather(coordinates: coordinates),
                    weatherService.getForecast(coordinates: coordinates)
                )
            }
        .receive(on: RunLoop.main)
        .sink { [weak self] completion in
            if case let .failure(error) = completion {
                self?.error = error
            }
        } receiveValue: { [weak self] weather, forecast in
            guard let self = self else { return }
            self.weather = weather
            self.hourlyList = Array(forecast.list.prefix(8))
            self.dailyList = self.configureDailyData(forecastList: forecast.list)
        }
        .store(in: &bag)
    }
    
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
