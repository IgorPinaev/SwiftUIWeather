//
//  DailyWeatherView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI

struct DailyWeatherView: View {
    let daily: DailyForecast
    
    var body: some View {
        HStack {
            Text(daily.day.capitalized)
            Spacer()
            HStack(spacing: 16) {
                Text(daily.minTemp.toTempString)
                Text(daily.maxTemp.toTempString)
            }
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView(daily: .init(
            maxTemp: 26.5,
            minTemp: 22,
            day: "Monday"
        ))
    }
}
