//
//  ViewController.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 29/03/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variable declaration
    @IBOutlet weak var vwBg: UIView!
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation? = nil
    
    
    // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        startLocationServices()
    }
    
    
    // MARK: - Location manager delegates
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
            print(" ")
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
                    
                }    // Showing current location in Tab bar for Today's weather
                DispatchQueue.main.async {
                    if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController) {
                        self.present(tabbar, animated: true, completion: nil)
                    }}
                }
                    
            
            
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        @unknown default:
            print(" ")
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

}

