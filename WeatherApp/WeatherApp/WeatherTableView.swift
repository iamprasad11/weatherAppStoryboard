//
//  WeatherTableView.swift
//  WeatherApp
//
//  Created by prasad_siriyannavar on 09/01/23.
//

import Foundation
import UIKit
import CoreData

var cityNames = [CityName]()

class WeatherTableView: UITableViewController{
    
    var firstLoad = true
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = tableView.dequeueReusableCell(withIdentifier: "weatherCellID", for: indexPath) as! WeatherCell
        
        let thisCity: CityName!
        thisCity = cityNames[indexPath.row]
        
        cityCell.cityCellLabel.text = thisCity.cityName
        
        return cityCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNames.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showCity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCity"){
            let indexPath = tableView.indexPathForSelectedRow!
            let cityDetail = segue.destination as? WeatherViewController
            let selectedCity : CityName
            selectedCity = cityNames[indexPath.row]
            cityDetail!.selectedCity = selectedCity
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            context.delete(cityNames[indexPath.row])
            
            do{
                try context.save()
                cityNames.removeAll()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityNames")
                do{
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let city = result as! CityName
                        cityNames.append(city)
                    }
                }catch{
                    print("Fetch Failed")
                }
                tableView.reloadData()
            }catch{
                print("Unable to delete the row")
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityNames")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let city = result as! CityName
                    cityNames.append(city)
                }
            }catch{
                print("Fetch Failed")
            }
        }
    }
}
