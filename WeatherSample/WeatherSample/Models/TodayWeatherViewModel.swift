//
//  TodayWeatherViewModel.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import Foundation
import UIKit

struct TodayWeatherViewModel {
    var cityName: String?
    var temperature: String?
    var weatherCondition: String?
    var humidity: String?
    var precipitationProbability: String?
    var pressure: String?
    var windSpeed: String?
    var windDeg: Double?
    var windDirection: String?
    var icon: UIImage?
    
    init(model: TodayWeather) {
        self.cityName = model.cityName
        self.weatherCondition = model.weatherCondition
        self.temperature = TodayWeatherViewModel.formatValue(value: model.temperature, endStringWith: "°")
        self.humidity = TodayWeatherViewModel.formatValue(value: model.humidity, endStringWith: "%")
        self.precipitationProbability = TodayWeatherViewModel.formatValue(value: model.precipitationProbability, endStringWith: " mm", castToInt: false)
        self.pressure = TodayWeatherViewModel.formatValue(value: model.pressure, endStringWith: " hPa")
        self.windSpeed = TodayWeatherViewModel.formatValue(value: model.windSpeed, endStringWith: " km/h")
        self.windDeg = model.windDeg
        self.windDirection = "NE"
        let weatherIcon = WeatherIcon(iconString: model.icon)
        self.icon = weatherIcon.image
    }
    
    static func formatValue(value: Double, endStringWith: String = "", castToInt: Bool = true) -> String {
        var returnValue: String
        let defaultString = "-"
        
        if value == Double.infinity {
            returnValue = defaultString
        }
        else if castToInt {
            returnValue = "\(Int(value))"
        }
        else {
            returnValue = "\(value)"
        }
        
        return returnValue.appending(endStringWith)
    }
}

