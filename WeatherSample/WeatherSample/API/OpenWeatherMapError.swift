//
//  OpenWeatherMapError.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import Foundation

enum OpenWeatherMapError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidaData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
}
