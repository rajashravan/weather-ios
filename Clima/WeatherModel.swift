//
//  WeatherModel.swift
//  Clima
//
//  Created by Raja Shravan on 2023-10-25.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch self.conditionId {
        case 200...232:
            return "cloud.bolt"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.fog"
        default:
            return "cloud"
        }
    }
}
