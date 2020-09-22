//
//  ViewController.swift
//  Clima
//
//  Created by Евангелина Клюкай on 27.08.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var searchTexField: UITextField!
    
    private let weatherManager = WeatherManager()
    private let locationService = LocationService()
    private let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
        weatherManager.delegate = self
        searchTexField.delegate = self
        
        if let cityName = UserDefaults.cityName {
           weatherManager.fetchWeather(cityName: cityName)
        }
    }
    
    private func alert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

private extension WeatherViewController {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationService.start()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTexField.endEditing(true)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTexField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
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

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            UserDefaults.cityName = weather.cityName
        } 
    }
    
    func didFailWithError(error: Error) {
         alert(error: error)
    }
}

extension WeatherViewController: LocationServiceDelegate {
    func didUpdateLocation(lat: Double, lon: Double) {
        weatherManager.fetchWeather(latitude: lat, longitute: lon)
    }
}

