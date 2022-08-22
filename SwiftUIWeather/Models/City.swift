//
//  City.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import Foundation

struct City: Decodable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    let localNames: [String: String]?
    
    var localName: String {
        localNames?[Locale.current.languageCode ?? "en"] ?? name
    }
}

extension City: Identifiable {
    
    var id: String {
        return name + "\(lat)" + "\(lon)"
    }
}
