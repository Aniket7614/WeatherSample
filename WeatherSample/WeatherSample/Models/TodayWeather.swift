//
//  TodayWeather.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import Foundation
struct TodayWeather: Decodable {
    var cityName: String = ""
    var countryName: String = ""
    var temperature: Double = Double.infinity
    var weatherCondition: String = ""
    var humidity: Double = Double.infinity
    var precipitationProbability: Double = Double.infinity
    var pressure: Double = Double.infinity
    var windSpeed: Double = Double.infinity
    var windDeg: Double = Double.infinity
    var icon: String = ""
}

extension TodayWeather {
    
    struct Key {
        static let cityName = "name"
        // main
        static let mainKey = "main"
        static let temperature = "temp"
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let countryName = "country"
        
        // rain
        static let rainKey = "rain"
        static let precipitation = "3h"
        
        // wind
        static let windKey = "wind"
        static let windSpeed = "speed"
        static let windDeg = "deg"
        
        // weather[0]
        static let weatherKey = "weather"
        static let icon = "icon"
        static let weatherCondition = "main"
    }
    
    init?(json: [String: AnyObject]) {
        if let cityNameString = json[Key.cityName] as? String{
            self.cityName = cityNameString
        }
        
        if let main = json[Key.mainKey] as? Dictionary<String, AnyObject> {
            if let temperatureValue = main[Key.temperature] as? Double {
                self.temperature = temperatureValue
            }
            
            if let humidityValue = main[Key.humidity] as? Double {
                self.humidity = humidityValue
            }
            
            if let countryValue = main[Key.countryName] as? String {
                self.countryName = countryValue
            }
            
            if let pressureValue = main[Key.pressure] as? Double {
                self.pressure = pressureValue
            }
        }
        
        if let rain = json[Key.rainKey] as? Dictionary<String, AnyObject> {
            if let precipitationValue = rain[Key.precipitation] as? Double {
                self.precipitationProbability = precipitationValue
            }
        }
        
        if let wind = json[Key.windKey] as? Dictionary<String, AnyObject> {
            if let windSpeedValue = wind[Key.windSpeed] as? Double {
                self.windSpeed = windSpeedValue
            }
            
            if let windDegValue = wind[Key.windDeg] as? Double {
                self.windDeg = windDegValue
            }
        }
        
        if let weather = json[Key.weatherKey] as? [Dictionary<String, AnyObject>] {
            if let weatherConditionValue = weather[0][Key.weatherCondition] as? String {
                self.weatherCondition = weatherConditionValue
            }
            
            if let iconValue = weather[0][Key.icon] as? String {
                self.icon = iconValue
            }
        }
    }
    
}


