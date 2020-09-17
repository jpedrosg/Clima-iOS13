//
//  WeatherManager.swift
//  Clima
//
//  Created by João Pedro Giarrante on 15/09/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}


struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c6456e5dbdc2121f694b9e713c111a68&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        var urlFinalString = urlString
        
        // Treating Spaces
        if let noSpacesUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            urlFinalString = noSpacesUrlString
        }
        
        // 1. Create a URL
        if let url = URL(string: urlFinalString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a Task
            let task = session.dataTask(with: url) { (data, response, error) in
                // I am inside an Closure!
                if let safeError = error {
                    self.delegate?.didFailWithError(safeError)
                    return
                }
                
                if let safeData = data {
                    // Explicit 'self' cause we are inside an Closure
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            // Using a Codable Struct to parse automatically
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let weatherModel = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
