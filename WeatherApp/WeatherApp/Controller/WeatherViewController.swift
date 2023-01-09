//
//  ViewController.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 02/01/23.
//

import UIKit
import CoreData


class WeatherViewController: UIViewController, WeatherManagerDelegate{
    
    var weatherManager = WeatherManager()
    
    var selectedCity: CityName? = nil
    
    @IBOutlet weak var temperatureLable: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
   @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityNameField: UITextField!
    
    @IBOutlet weak var validationMessage: UILabel!
    
    var city_name: String? = ""
    
    @IBAction func enterButton(_ sender: Any) {
        
        city_name = cityNameField.text
        validationMessage.isHidden = true
        if (city_name?.isEmpty)! {
            validationMessage.isHidden = false
            validationMessage.text = "Please enter city name"
            return
        }
        
        weatherManager.fetchWeather(cityName: city_name!.trimmingCharacters(in: .whitespaces))
    }
    
    @IBAction func addToFav(_ sender: Any) {
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CityNames", in: context)
        let newCity = CityName(entity: entity!, insertInto: context)
        newCity.id = cityNames.count as NSNumber
        newCity.cityName = cityNameLabel.text
        do{
            try context.save()
            cityNames.append(newCity)
        }
        catch{
            print("context save error")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameField.delegate = self
        weatherManager.delegate = self
        validationMessage.isHidden = true
        
        if(selectedCity != nil){
            weatherManager.fetchWeather(cityName: selectedCity!.cityName)
        }
    }
    
    
    func didUpdateWeather(_ weather: WeatherModel) {
        print("WVC: \(weather.tempString)")
        
        DispatchQueue.main.async {
        self.temperatureLable.text = weather.tempString
        self.weatherImageView.image = UIImage(systemName: weather.conditionName)
        self.cityNameLabel.text = weather.cityName
        }
    }
}

extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

