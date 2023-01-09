//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 02/01/23.
//

import Foundation
import CoreData


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    // computed prop

    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 800...804:
            return "cloud"
        default:
            return "sun.min"
        }
    }
    
    var tempString: String {
        return String(format: "%.1f", temperature) + " °C"
    }

}


