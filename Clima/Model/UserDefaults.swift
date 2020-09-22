//
//  UserDefaults.swift
//  Clima
//
//  Created by Евангелина Клюкай on 22.09.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation

class UserDefaults {
    
    private enum SettingsKeys: String {
        case cityName
    }
    
    static var cityName: String? {
        get {
            return Foundation.UserDefaults.standard.string(forKey: SettingsKeys.cityName.rawValue)
        } set {
            let defaults = Foundation.UserDefaults.standard
            let key = SettingsKeys.cityName.rawValue
            if let name = newValue {
                print("value: \(name) was added to key \(key)")
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
