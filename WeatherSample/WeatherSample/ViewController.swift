//
//  ViewController.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 29/03/23.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Variable declaration
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var vwBg: UIView?
    @IBOutlet weak var lblWindDirection: UILabel?
    @IBOutlet weak var lblWindSpeed: UILabel?
    @IBOutlet weak var lblPerciption: UILabel?
    @IBOutlet weak var lblPressure: UILabel?
    @IBOutlet weak var lblHumidity: UILabel?
    @IBOutlet weak var lblWeatherCondition: UILabel?
    @IBOutlet weak var lblTemperature: UILabel?
    @IBOutlet weak var lblCityName: UILabel?
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation? = nil
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var todayWeatherViewModel: TodayWeatherViewModel!

    
    
    // View Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createGradientColorForBackgroundView()
        // location manager setup
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupActivityIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLocationServices()
        //internet check with alamofire
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            self.checkPermissions()
        }
        else{
            print("No! internet is not available.")
            self .alertInternetAccessNeeded()
        }
    }
    
    
    
    func checkPermissions() {
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                self.getTodayWeather()
            }
            else {
                print("not enable")
            }
        }
    }
    
    func getTodayWeather() {
        toggleRefreshAnimation(on: true)
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    // update UI
                    self.displayWeather(using: todayWeatherViewModel)
                    self.toggleRefreshAnimation(on: false)
                }
            }
        }
    }
    
    func displayWeather(using viewModel: TodayWeatherViewModel) {
        self.lblCityName?.text = viewModel.cityName
        
        self.lblTemperature?.text = viewModel.temperature
        self.lblWeatherCondition?.text = viewModel.weatherCondition
        self.lblHumidity?.text = viewModel.humidity
        self.lblPerciption?.text = viewModel.precipitationProbability
        self.lblPressure?.text = viewModel.pressure
        self.lblWindSpeed?.text = viewModel.windSpeed
        self.lblWindDirection?.text = viewModel.windDirection
        self.weatherImage?.image = viewModel.icon
        
        print (viewModel.cityName)
        print (viewModel.precipitationProbability)
        print (viewModel.pressure)
    }
    
    func toggleRefreshAnimation(on: Bool) {
        if on {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }


    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Internet Methods
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    func alertInternetAccessNeeded() {
        
        let alert = UIAlertController(
            title: "Need Interet Access",
            message: "Internet access is required",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
        present(alert, animated: true, completion: nil)
    }
    
    // Monitor location services authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        @unknown default:
            print("")
        }
        
        // Get the device's current location and assign the latest CLLocation value to your tracking variable
        func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {
            self.currentLocation = locations.last
        }
    }
    
    func startLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization() // This is where you request permission to use location services
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
//                if let tabbar = (storyboard?.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController) {
//                    self.present(tabbar, animated: true, completion: nil)
                }
                
            }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        @unknown default:
            print("")
        }}
    
    
    
    func alertLocationAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Location Access",
            message: "Location access is required for including the location of the hazard. Please give the permission and restart the application",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Location Access",
                                      style: .cancel,
                                      handler: { (alert) -> Void in
                                        UIApplication.shared.open(settingsAppURL,
                                                                  options: [:],
                                                                  completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    
    
    func createGradientColorForBackgroundView(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        // Set the gradient colors
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor
        ]

        // Set the gradient direction (optional)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Add the gradient layer to the view's layer
        view.layer.addSublayer(gradientLayer)
    }


}

