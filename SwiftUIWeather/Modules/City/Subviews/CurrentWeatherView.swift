//
//  CurrentWeatherView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    let weather: CurrentWeather
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text(weather.name)
                    .font(.title)
                Text(weather.main.temp.toTempString)
                    .font(.custom("System", size: 56))
                Text(weather.weather.first?.description ?? "")
            }
            Spacer()
        }
        .padding()
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(weather: CurrentWeather(
            name: "Yekaterinburg",
            coord: .init(
                lat: 123,
                lon: 123
            ),
            main: .init(
                temp: 24.5,
                tempMax: 26,
                tempMin: 22
            ),
            weather: [
                .init(
                    main: "Clouds",
                    description: "clouds"
                )
            ]
        ))
    }
}
