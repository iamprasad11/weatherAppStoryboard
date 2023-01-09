//
//  WeatherData.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 02/01/23.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
    let description: String
}
