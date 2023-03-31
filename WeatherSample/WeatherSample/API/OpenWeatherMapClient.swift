//
//  OpenWeatherMapClient.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import Foundation
import Alamofire

class OpenWeatherMapClient {
    
    // MARK: - Variable declaration
    static let client = OpenWeatherMapClient()
    private let apiKey = "02e27e214000ccc2fb29db822575dcb2"
    lazy var baseUrl: URL = {
        return URL(string: Constants.API_BASE_URL)!
    }()
    
    typealias TodayWeatherCompletionHandler = (TodayWeather?, OpenWeatherMapError?) -> Void
    typealias ForecastWeatherCompletionHandler = ([ForecastWeather]?, OpenWeatherMapError?) -> Void
    
     //MARK: - Making network connection- With Almofire for Today weather
    func getTodayWeather(at coordinate: Coordinate, completionHandler completion: @escaping TodayWeatherCompletionHandler) {
        guard let url = URL(string: Constants.API_ENDPOINT_CURRENT_WEATHER, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        let parameters: Parameters = self.buildParameters(coordinate: coordinate)
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let JSON = response.result.value as? Dictionary<String, AnyObject> else {
                completion(nil, .invalidaData)
                return
            }
            print (url)
            print (parameters)
            print (JSON)
            
            if response.response?.statusCode == 200 {
                guard let currentWeather = TodayWeather(json: JSON) else {
                    completion(nil, .jsonParsingFailure)
                    print (JSON)
                    return
                }
                completion(currentWeather, nil)
            }
            else {
                completion(nil, .responseUnsuccessful)
            }}}
    
    
    //MARK: - Making network connection- With Almofire for Today weather for Cities
   func getTodayWeatherByCities(at strCity: String, completionHandler completion: @escaping TodayWeatherCompletionHandler) {
       guard let url = URL(string: Constants.API_ENDPOINT_CURRENT_WEATHER, relativeTo: baseUrl) else {
           completion(nil, .invalidUrl)
           return
       }
       let parameters: Parameters = self.buildParametersByCities(strCity: strCity)
       Alamofire.request(url, parameters: parameters).responseJSON { response in
           guard let JSON = response.result.value as? Dictionary<String, AnyObject> else {
               completion(nil, .invalidaData)
               return
           }
           print (url)
           print (parameters)
           print (JSON)
           
           if response.response?.statusCode == 200 {
               guard let currentWeather = TodayWeather(json: JSON) else {
                   completion(nil, .jsonParsingFailure)
                   print (JSON)
                   return
               }
               completion(currentWeather, nil)
           }
           else if response.response?.statusCode == 404 {
               DispatchQueue.main.async {
                }
           }
           else {
               completion(nil, .responseUnsuccessful)
           }}}
   
    
    //MARK: - Making network connection- With Almofire for Forecast weather
    func getForecastWeather(at coordinate: Coordinate, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        guard let url = URL(string: Constants.API_ENDPOINT_FORECAST_WEATHER, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let parameters: Parameters = self.buildParameters(coordinate: coordinate)
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let JSON = response.result.value else {
                completion(nil, .invalidaData)
                return
            }
            print (url)
            print (parameters)
            print (JSON)
            if response.response?.statusCode == 200 {
                var forecasts: [ForecastWeather] = []
                print (JSON)
                if let dict = JSON as? Dictionary<String, AnyObject>{
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for obj in list {
                            let forecast = ForecastWeather(json: obj)
                            forecasts.append(forecast!)
                        }}}
                
                completion(forecasts, nil)
            }
            else {
                completion(nil, .responseUnsuccessful)
            }}}
    

    //MARK: - Defining parameter i.e API Key, Metrics, lat and long
    func buildParameters(coordinate: Coordinate) -> Parameters {
        let parameters: Parameters = [
            "appid": self.apiKey,
            "units": "metric",
            "lat": String(coordinate.latitude),
            "lon": String(coordinate.longitude)
        ]
        return parameters
    }
    
    //MARK: - Defining parameter i.e API Key, Metrics, cities- This is to get the United state cities
    func buildParametersByCities(strCity: String) -> Parameters {
        let parameters: Parameters = [
            "appid": self.apiKey,
            "units": "metric",
            "q": strCity + ",US"
        ]
        return parameters
    }
}

