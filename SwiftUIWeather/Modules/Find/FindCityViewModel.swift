//
//  FindCityViewModel.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import Foundation
import Combine

final class FindCityViewModel: ObservableObject {
    
    @Published var city = ""
    @Published private (set) var cityList = [City]()
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    init() {
        $city
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] city in
                self!.weatherService.findCity(name: city)
                    .replaceError(with: [])
            }
            .assign(to: \.cityList, on: self)
            .store(in: &bag)
            
    }
}
