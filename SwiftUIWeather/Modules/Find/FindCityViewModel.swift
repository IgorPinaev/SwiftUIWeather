//
//  FindCityViewModel.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import Foundation
import Combine

final class FindCityViewModel: ObservableObject {
    
    @Published var cityName = ""
    @Published private (set) var cityList = [City]()
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    init() {
        $cityName
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weatherService] city in
                weatherService.findCity(name: city)
                    .replaceError(with: [])
            }
            .assign(to: \.cityList, on: self)
            .store(in: &bag)
            
    }
}
