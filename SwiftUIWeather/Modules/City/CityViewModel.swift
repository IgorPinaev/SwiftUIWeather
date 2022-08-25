//
//  CityViewModel.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine
import CoreLocation

final class CityViewModel: NSObject, ObservableObject {
    
    var isNeedUpdate = PassthroughSubject<Void, Never>()
    
    @Published private (set) var weather: CurrentWeather?
    @Published private (set) var hourlyList: [Forecast]?
    @Published private (set) var dailyList: [DailyForecast]?
    @Published private (set) var error: Error?
    @Published private (set) var currentCityName: String?
    
    private let coordinates: Coordinates?
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    private let locationService = LocationService()
    
    init(coordinates: Coordinates?) {
        self.coordinates = coordinates
        super.init()
        configurePublishers()
    }
    
    func saveCity(city: City) {
        CityEntity.save(from: city)
        CoreDataService.shared.saveContext()
    }
}

private extension CityViewModel {
    
    func configurePublishers() {
        if coordinates == nil {
            locationService.start()
        }
        
        let presetCoordinates = isNeedUpdate
            .compactMap { [weak self] _ in
                self?.coordinates
            }
        
        let geoCoordinates = Publishers.CombineLatest(isNeedUpdate, locationService.$location)
            .compactMap { _ , location -> Coordinates? in
                guard let coordinate = location?.coordinate else { return nil }
                return Coordinates(
                    lat: coordinate.latitude,
                    lon: coordinate.longitude
                )
            }
        
        Publishers.Merge(presetCoordinates, geoCoordinates)
            .flatMap { [weatherService] coordinates in
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
        
        locationService.$currentCityName
            .assign(to: &$currentCityName)
            
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
