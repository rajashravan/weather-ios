//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation() // sometimes this causes error on initial load of app if
        // user has not already given us permissions
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func GPSButtonPressed(_ sender: UIButton) {
        self.locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            print(location)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        print("got location")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("got error")
        print(error)
    }
}



//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        let userSearch = searchTextField.text!
        print(userSearch)
        searchTextField.endEditing(true)
    }
    
    // delegate hook
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        searchTextField.endEditing(true)
        return false
    }
    
    // delegate hook
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = searchTextField.text
        if city != nil {
            weatherManager.fetchWeather(cityName: city!)
        }
                
        searchTextField.text = ""
        textField.placeholder = "Search!"
    }
    
    // delegate hook
    // called when something (ex. user action) is about to cause
    // the end of textfield editting
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type something!"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { // need this or else will fail
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
