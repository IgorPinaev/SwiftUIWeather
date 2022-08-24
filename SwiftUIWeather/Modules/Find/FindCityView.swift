//
//  FindCityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import SwiftUI

struct FindCityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = FindCityViewModel()
    
    @State private var city: City?
    @State private var isCitySaved: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CityEntity.name, ascending: true)],
        animation: .default
    )
    private var cityEntities: FetchedResults<CityEntity>
    
    var body: some View {
        NavigationView {
            getCityList()
                .searchable(text: $viewModel.city, prompt: "Search city")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $city) { [isCitySaved] city in
                    CityView(
                        city: city,
                        isCitySaved: isCitySaved
                    )
                }
        }
    }
}

private extension FindCityView {
    
    @ViewBuilder
    func getCityList() -> some View {
        if viewModel.city.isEmpty {
            List {
                ForEach(cityEntities) { cityEntity in
                    Text(cityEntity.name)
                        .padding()
                        .onTapGesture {
                            self.city = City(from: cityEntity)
                            self.isCitySaved = true
                        }
                    
                }
                .onDelete(perform: deleteCity)
            }
        } else {
            List(viewModel.cityList) { city in
                Text(city.name)
                    .padding()
                    .onTapGesture {
                        self.city = city
                        self.isCitySaved = cityEntities.contains(where: { $0.id == city.id })
                    }
            }
        }
    }
}

private extension FindCityView {
    
    func deleteCity(offsets: IndexSet) {
        withAnimation {
            offsets.map { cityEntities[$0] }.forEach(viewContext.delete)
            
            CoreDataService.shared.saveContext()
        }
    }
}

struct FindCityView_Previews: PreviewProvider {
    static var previews: some View {
        FindCityView()
            .environment(\.managedObjectContext, CoreDataService.shared.viewContext)
    }
}
