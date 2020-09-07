//
//  WeatherManager.swift
//  Clima
//
//  Created by Евангелина Клюкай on 02.09.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherManager {
    
   private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=05d22dff3398e1110cf8de7326960bdd&units=metric"
   private let session = URLSession(configuration: .default)
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(witch: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(witch: urlString)
    }
    
    func performRequest(witch urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let task = session.dataTask(with: url) { (data,response, error) in
                if error != nil {
                    self.delegate?.didFailWitchError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            print(error)
            return nil
        }
    }
}

