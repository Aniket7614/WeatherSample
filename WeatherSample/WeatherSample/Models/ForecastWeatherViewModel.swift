//
//  ForecastWeatherViewModel.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import Foundation
import UIKit

struct ForecastWeatherViewModel {
    var weekday: String?
    var temperature: String?
    var weatherCondition: String?
    var icon: UIImage?
    private let defaultString = "-"
    
    init(model: ForecastWeather) {
        self.weekday = ForecastWeatherViewModel.getDayOfWeek(from: model.date)
        self.weatherCondition = model.weatherCondition
        self.temperature = TodayWeatherViewModel.formatValue(value: model.temperature, endStringWith: "°")
        let weatherIcon = WeatherIcon(iconString: model.icon)
        self.icon = weatherIcon.image
    }
    
    static func getDayOfWeek(from fromDate: Double) -> String {
        let date = Date(timeIntervalSince1970: fromDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE h a"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
}

