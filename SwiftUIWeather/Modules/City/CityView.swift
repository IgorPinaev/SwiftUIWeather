//
//  CityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI
import Combine

struct CityView: View {
    let city: City
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel = CityViewModel()
    
    var body: some View {
        NavigationView {
        VStack {
            if let weather = viewModel.weather,
               let hourly = viewModel.hourlyList,
               let daily = viewModel.dailyList {
                configureWeatherList(
                    weather: weather,
                    hourlyList: hourly,
                    dailyList: daily
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Отменить") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    
                }
            }
        }
        .navigationBarHidden(!presentationMode.wrappedValue.isPresented)
        }
        .onAppear {
            viewModel.getCurrentWeather(coordinates: .init(
                lat: city.lat,
                lon: city.lon
            ))
        }
    }
}

private extension CityView {
    
    func configureWeatherList(
        weather: CurrentWeather,
        hourlyList: [Forecast],
        dailyList: [DailyForecast]
    ) -> some View {
        List {
            CurrentWeatherView(
                weather: weather,
                name: city.localName
            )
            configureHourlyWeatherSection(hourlyList: hourlyList)
            configureDailyWeatherSection(dailyList: dailyList)
        }
    }
    
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
        CityView(
            city: .init(
                name: "Yekaterinburg",
                lat: 56.839104,
                lon: 60.60825,
                localNames: nil
            )
        )
    }
}
