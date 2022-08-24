//
//  SwiftUIWeatherApp.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI

@main
struct SwiftUIWeatherApp: App {

    var body: some Scene {
        WindowGroup {
            MainPageView()
                .environment(\.managedObjectContext, CoreDataService.shared.viewContext)
        }
    }
}
