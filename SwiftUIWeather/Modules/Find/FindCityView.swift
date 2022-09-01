//
//  FindCityView.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//

import SwiftUI

struct FindCityView: View {
    @Binding var tabSelection: Int
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel = FindCityViewModel()
    
    @State private var cityToShow: City?
    @State private var isCitySaved: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \CityEntity.name,
            ascending: true
        )],
        animation: .default
    )
    private var cityEntities: FetchedResults<CityEntity>
    
    var body: some View {
        NavigationView {
            getCityList()
                .foregroundColor(.primary)
                .searchable(text: $viewModel.cityName, prompt: "Search city")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $cityToShow) { [isCitySaved] city in
                    CityView(
                        city: city,
                        isCitySaved: isCitySaved,
                        isPresented: true
                    )
                }
        }
    }
}

private extension FindCityView {
    
    @ViewBuilder
    func getCityList() -> some View {
        if viewModel.cityName.isEmpty {
            List {
                Button("Current city") {
                    tabSelection = 0
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                
                ForEach(Array(cityEntities.enumerated()), id: \.element) { cityEntity in
                    Button(cityEntity.element.name) {
                        tabSelection = cityEntity.offset + 1
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                }
                .onDelete(perform: deleteCity)
            }
        } else {
            List(viewModel.cityList) { city in
                Button(city.localName) {
                    cityToShow = city
                    isCitySaved = cityEntities.contains(where: { $0.id == city.id })
                }
                .padding()
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
        FindCityView(tabSelection: .constant(1))
            .environment(\.managedObjectContext, CoreDataService.shared.viewContext)
    }
}
