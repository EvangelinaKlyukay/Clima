//
//  WeatherManager.swift
//  Clima
//
//  Created by Евангелина Клюкай on 02.09.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: class {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
    private let session = URLSession(configuration: .default)
    
    weak var delegate: WeatherManagerDelegate?
    
    func makeUrl(q: String?, coords: (lat: Double, lon: Double)?) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "05d22dff3398e1110cf8de7326960bdd"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        if let q = q {
            components.queryItems?.append(URLQueryItem(name: "q", value: q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        
        if let coords = coords {
            components.queryItems?.append(URLQueryItem(name: "lat", value: "\(coords.lat)"))
            components.queryItems?.append(URLQueryItem(name: "lon", value: "\(coords.lon)"))
        }
        return components.url
    }
    
    func fetchWeather(cityName: String) {
        guard let url = self.makeUrl(q: cityName, coords: nil) else {
            return
        }
        self.performRequest(witch: url)
    }
    
    func fetchWeather(latitude: Double, longitute: Double) {
        guard let url = self.makeUrl(q: nil, coords: (latitude, longitute)) else {
            return
        }
        performRequest(witch: url)
    }
    
    private func performRequest(witch url: URL) {
        
        let task = session.dataTask(with: url) { (data,response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
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
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
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

