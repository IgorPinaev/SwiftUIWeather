//
//  CityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import SwiftUI
import Combine

struct CityView: View {
    let city: City?
    let isCitySaved: Bool
    let isPresented: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: CityViewModel
    
    init(city: City?, isCitySaved: Bool, isPresented: Bool) {
        self.city = city
        self.isCitySaved = isCitySaved
        self.isPresented = isPresented
        
        viewModel = CityViewModel(coordinates: city?.coordinates)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLocationEnabled == false {
                disableLocationError
            } else {
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
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
            viewModel.isNeedUpdate.send()
        }
    }
}

private extension CityView {
    
    var disableLocationError: some View {
        VStack(spacing: 8) {
            Text("Allow the app to detect your current location")
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
                
            Button("Open settings") {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 20))
            .padding()
            .background(.blue)
            .cornerRadius(10)
        }
    }
    
    var toolBarItems: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading)
            Spacer()
            if let city = city, !isCitySaved {
                Button("Add") {
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
                name: city?.localName ?? viewModel.currentCityName ?? ""
            )
            .listRowBackground(Color.clear)
            if let hourlyList = hourlyList,
               let dailyList = dailyList{
                configureHourlyWeatherSection(hourlyList: hourlyList)
                configureDailyWeatherSection(dailyList: dailyList)
            }
        }
    }
    
    func configureHourlyWeatherSection(hourlyList: [Forecast]) -> some View {
        Section(header: Text("Hourly")) {
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
        Section(header: Text("Daily")) {
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
