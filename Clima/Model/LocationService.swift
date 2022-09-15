//
//  LocationService.swift
//  Clima
//
//  Created by Евангелина Клюкай on 08.09.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lon: Double)
}

class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?
    private let manager = CLLocationManager()
}

extension LocationService {
    func start() {
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            manager.requestLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            self.delegate?.didUpdateLocation(lat: lat, lon: lon)
        }
    }
}
