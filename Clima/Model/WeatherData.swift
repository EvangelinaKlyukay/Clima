//
//  WeatherDate.swift
//  Clima
//
//  Created by Евангелина Клюкай on 31.08.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
