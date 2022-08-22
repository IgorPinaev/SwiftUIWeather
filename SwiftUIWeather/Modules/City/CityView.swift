//
//  CityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI
import Combine

struct CityView: View {
    @ObservedObject private var viewModel = CityViewModel()
    
    var body: some View {
        NavigationView {
            if let weather = viewModel.weather,
               let hourly = viewModel.hourlyList,
               let daily = viewModel.dailyList {
                List {
                    CurrentWeatherView(weather: weather)
                    configureHourlyWeatherSection(hourlyList: hourly)
                    configureDailyWeatherSection(dailyList: daily)
                }
            }
        }
    }
}

private extension CityView {
    
    func configureHourlyWeatherSection(hourlyList: [Forecast]) -> some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(hourlyList, id: \.self) { forecast in
                        HourlyWeatherView(forecast: forecast)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    func configureDailyWeatherSection(dailyList: [DailyForecast]) -> some View {
        Section {
            VStack(spacing: 24) {
                ForEach(dailyList, id: \.self) { daily in
                    DailyWeatherView(daily: daily)
                }
            }
            .padding(.vertical)
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
