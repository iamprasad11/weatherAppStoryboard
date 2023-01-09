//
//  CityNames.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 09/01/23.
//

import Foundation
import CoreData

@objc(CityNames)

class CityName: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var cityName: String!
}
