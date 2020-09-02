//
//  ViewController.swift
//  Clima
//
//  Created by Евангелина Клюкай on 27.08.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit
import CoreLocation

class WeaterViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTexField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTexField.delegate = self
    }
}

extension WeaterViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTexField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTexField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTexField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTexField.text = ""
    }
}

extension WeaterViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    
    func didFailWitchError(error: Error) {
        print(error)
    }
}

extension WeaterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.latitude
            weatherManager.fetchWeather(latitude:lat, longitute:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

