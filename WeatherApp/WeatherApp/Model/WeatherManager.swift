//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 02/01/23.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
}

struct WeatherManager {
    let baseUrl =
    "https://api.openweathermap.org/data/2.5/weather?appid=c66bef69fe6ff0a6131feef0006ab5e6&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(baseUrl)&q=\(cityName)"
        print("Full URL : ", urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchLocation(lat: Double, long: Double){
        let locString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=c66bef69fe6ff0a6131feef0006ab5e6&units=metric"
        print(locString)
        performRequest(urlString: locString)
    }
    
    private func performRequest(urlString: String){
        // creating url
        if let url = URL(string: urlString){
            // creating session
            let session = URLSession(configuration: .default)
            // giving task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print("ERROR: ", error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            // starting task
            task.resume()
        }
    }
    private func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("Temp: \(decodedData.main.temp) in city: \(decodedData.name) : desc: \(decodedData.weather[0].description)")

            let weather = WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)

            print("Weather Symbol: \(weather.conditionName)")

            return weather
        }catch{
            print(error)
            return nil
        }
    }
}
