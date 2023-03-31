//
//  FirstViewController.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire

var todayWeatherViewModel: TodayWeatherViewModel!

class TodayWeatherViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    // MARK: - Variable declaration
    @IBOutlet weak var vwBgWeather: UIView!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherConditionLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var precipitationLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var searchTextFieldCity : String = ""
 
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGeneralMethods()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //internet check with alamofire
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            self.checkPermissions()
        }
        else{
            print("No! internet is not available.")
            self .alertInternetAccessNeeded()
        }}
    
    
    // MARK: - Internet Methods
    func setUpGeneralMethods(){
        // location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
        setupActivityIndicator()
        setUpSearchController()
    }
    
    
    // MARK: - Internet Methods
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }}

    
    // MARK: - Set Up Search controller
    func setUpSearchController(){
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
            let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            searchTextField.attributedPlaceholder = attributedPlaceholder
        }}
    
    
    // MARK: - Search Bar delegates
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Handle the search bar becoming active
        tableView.isHidden = false
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Handle the search bar becoming inactive
        self.searchTextFieldCity = searchBar.text ?? ""
        getTodayWeatherByCities()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTextFieldCity = searchBar.text ?? ""
    }
   
    
   

    // MARK: - Search bar updating delegates
// Search result updating delegate
    func updateSearchResults(for searchController: UISearchController) {
        // Update the search results based on the user's search query

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

    // MARK: - Check Permissions
    func checkPermissions() {
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                self.getTodayWeather()
            }else {
                print("not enable")
            }}}
    
    
    // MARK: - Get weather for US cities
    func getTodayWeatherByCities(){
        toggleRefreshAnimation(on: true)
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeatherByCities(at: self.searchTextFieldCity){
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    
                    // update UI
                    self.displayWeather(using: todayWeatherViewModel)
                    // save weather
                    self.toggleRefreshAnimation(on: false)
                }}}}
        
    
    
    // MARK: - Get Today's Weather
    func getTodayWeather() {
        toggleRefreshAnimation(on: true)
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    // update UI
                    self.displayWeather(using: todayWeatherViewModel)
                    // save weather
                    self.toggleRefreshAnimation(on: false)
                }}}}
    
    
    
    // MARK: - Display data
    func displayWeather(using viewModel: TodayWeatherViewModel) {
        // Data Binding
        self.cityNameLabel.text = viewModel.cityName
        self.temperatureLabel.text = viewModel.temperature
        self.weatherConditionLabel.text = viewModel.weatherCondition
        self.humidityLabel.text = viewModel.humidity
        self.pressureLabel.text = viewModel.pressure
        self.windSpeedLabel.text = viewModel.windSpeed
        self.windDirectionLabel.text = viewModel.windDirection
        self.weatherImageView.image = viewModel.icon
    }
    
    // MARK: - Setting Up Activity indicator
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
    }

    func toggleRefreshAnimation(on: Bool) {
        if on {
            activityIndicator.startAnimating()
            activityIndicator.isUserInteractionEnabled = true
        }else {
            activityIndicator.stopAnimating()
            activityIndicator.isUserInteractionEnabled = false
        }}}


// MARK: - Creating Extension for CLLocation Manager Delegate
extension TodayWeatherViewController: CLLocationManagerDelegate {
    // new location data is available
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // update shaped instance
        Coordinate.sharedInstance.latitude = (manager.location?.coordinate.latitude)!
        Coordinate.sharedInstance.longitude = (manager.location?.coordinate.longitude)!
        // request current weather
        self.getTodayWeather()
    }
    
    // the location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        Coordinate.checkForGrantedLocationPermissions() { allowed in
            if !allowed {
                print("not enable")
            }}}
    
}




