//
//  FindCityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import SwiftUI

struct FindCityView: View {
    @ObservedObject private var viewModel = FindCityViewModel()
    
    @State private var city: City?
    
    var body: some View {
        NavigationView {
            List(viewModel.cityList) { city in
                Text(city.name)
                    .padding()
                    .onTapGesture {
                        self.city = city
                    }
            }
            .searchable(text: $viewModel.city, prompt: "Search city")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $city) { CityView(city: $0) }
        }
    }
}

struct FindCityView_Previews: PreviewProvider {
    static var previews: some View {
        FindCityView()
    }
}
