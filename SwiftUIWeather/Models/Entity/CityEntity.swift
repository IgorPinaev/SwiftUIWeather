//
//  CityEntity.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 22.08.2022.
//
//

import Foundation
import CoreData

@objc(CityEntity)
public class CityEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

    static func save(from city: City) {
        let cityEntity = CityEntity(context: CoreDataService.shared.viewContext)
        
        cityEntity.name = city.localName
        cityEntity.lat = city.lat
        cityEntity.lon = city.lon
    }
}

extension CityEntity : Identifiable {

    public var id: String {
        return "\(lat) \(lon)"
    }
}
