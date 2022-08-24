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
    let isCitySaved: Bool
    let isPresented: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel = CityViewModel()
    
    var body: some View {
        VStack {
            if isPresented {
                toolBarItems
                Spacer()
            }
            configureWeatherList(
                weather: viewModel.weather,
                hourlyList: viewModel.hourlyList,
                dailyList: viewModel.dailyList
            )
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
    
    var toolBarItems: some View {
        HStack {
            Button("Отменить") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading)
            Spacer()
            if !isCitySaved {
                Button("Добавить") {
                    viewModel.saveCity(city: city)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing)
            }
        }
        .padding(.top)
    }
    
    func configureWeatherList(
        weather: CurrentWeather?,
        hourlyList: [Forecast]?,
        dailyList: [DailyForecast]?
    ) -> some View {
        List {
            CurrentWeatherView(
                weather: weather,
                name: city.localName
            )
            if let hourlyList = hourlyList,
               let dailyList = dailyList{
                configureHourlyWeatherSection(hourlyList: hourlyList)
                configureDailyWeatherSection(dailyList: dailyList)
            }
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
            ),
            isCitySaved: false,
            isPresented: false
        )
    }
}
