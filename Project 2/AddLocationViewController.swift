//
//  AddLocationViewController.swift
//  Project 2
//
//  Created by Raman Singh on 2022-11-29.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController ,CLLocationManagerDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UITextField!
    
    @IBOutlet weak var conditionLabel: UITextField!
    
    var searchText: String = ""
    var results:[WeatherConditions1] = []
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySampleImageForDemo(code: -1)
         locationManager.delegate = self
         loadWeatherCondition()
         
         self.searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText = searchTextField.text!

        loadWeather(search: searchText)
            return true
        }
   
    
    private func displaySampleImageForDemo(code: Int) {
    let config = UIImage.SymbolConfiguration (paletteColors: [
    .systemRed,
    .systemYellow
    ])
    weatherConditionImage.preferredSymbolConfiguration=config
        
        print(code)
        
        if code == 1000 {
            weatherConditionImage.image = UIImage (systemName: "sun.max")
        }else if code == 1003{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.circle.fill")

        }else if code == 1006{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun")

        }else if code == 1009{
            weatherConditionImage.image = UIImage (systemName: "cloud")

        }else if code == 1030{
            weatherConditionImage.image = UIImage (systemName: "smoke.fill")

        }else if code == 1063{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.rain.circle")

        }else if code == 1066{
            weatherConditionImage.image = UIImage (systemName: "cloud.snow")

        }else if code == 1069{
            weatherConditionImage.image = UIImage (systemName: "cloud.sleet")

        }else if code == 1072{
            weatherConditionImage.image = UIImage (systemName: "cloud.drizzle.circle.fill")

        }else if code == 1087{
            weatherConditionImage.image = UIImage (systemName: "cloud.bolt.rain")

        }else if code == 1114{
            weatherConditionImage.image = UIImage (systemName: "cloud.snow")

        }else if code == 1117{
            weatherConditionImage.image = UIImage (systemName: "cloud.rain.circle")

        }else if code == 1135{
            weatherConditionImage.image = UIImage (systemName: "cloud.fog")

        }else if code == 1147{
            weatherConditionImage.image = UIImage (systemName: "cloud.fog")

        }else if code == 1150{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.rain.fill")

        }else if code == 1153{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.rain.fill")

        }else if code == 1168{
            weatherConditionImage.image = UIImage (systemName: "cloud.snow.circle")

        }else if code == 1171{
            weatherConditionImage.image = UIImage (systemName: "cloud.sleet")

        }else if code == 1180{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.rain")

        }else if code == 1183{
            weatherConditionImage.image = UIImage (systemName: "cloud.rain")

        }else if code == 1186{
            weatherConditionImage.image = UIImage (systemName: "cloud.sun.rain.circle")

        }else if code == 1189 || code == 1192 || code == 1195{
            weatherConditionImage.image = UIImage (systemName: "cloud.rain.circle.fill")

        }else if code == 1198{
            weatherConditionImage.image = UIImage (systemName: "cloud.snow.circle")

        }else if code == 1201{
            weatherConditionImage.image = UIImage (systemName: "cloud.snow.fill")

        }else if code == 1204 || code == 1207{
            weatherConditionImage.image = UIImage (systemName: "cloud.sleet")

        }else if code == 1210 || code == 1213 || code == 1216 || code == 1219 || code == 1222 || code == 1225 || code == 1237 || code == 1255 || code == 1258 || code == 1261 || code == 1264{
            weatherConditionImage.image = UIImage (systemName: "snowflake.circle")

        }else if code == 1240 || code == 1243 || code == 1246 || code == 1249 || code == 1252 {
            weatherConditionImage.image = UIImage (systemName: "cloud.rain.fill")

        }
        else if code == 1273 || code == 1276  {
            weatherConditionImage.image = UIImage (systemName: "cloud.bolt.rain")

        }
        else if code == 1279 || code == 1282  {
            weatherConditionImage.image = UIImage (systemName: "cloud.snow.fill")

        }else{
            weatherConditionImage.image = UIImage (systemName: "sun.max.trianglebadge.exclamationmark")

        }
        
    }

    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func onLocationTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func displayLocation (locationText: String) {
    locationLabel.text = locationText
    }
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
        searchText = searchTextField.text!
        loadWeather(search: searchText)
    }
    
    func loadWeather(search: String?) {
            guard let search = search else {
                return
            }
            // Step 1: Get URL
            guard let url = getURL (query: search) else {
                print ("Could not get URL")
                return
            }
            // Step 2: Create URLSession
            let session = URLSession.shared
            // Step 3: Create task for session
            let dataTask = session.dataTask(with: url) { data, response, error in
                // network call finished
                
                guard error == nil else {
                    print ("Received error")
                    return
                }
                guard let data = data else
                {
                    print ("No data found" )
                    return
                }
                
                if let weatherResponse = self.parseJson(data: data){
                    print(weatherResponse.location.name)
                    print(weatherResponse.current.temp_c)
                    //print(self.toggleValue)
                    DispatchQueue.main.async {
                        self.locationLabel.text = weatherResponse.location.name
                        self.temperatureLabel.text = "\(weatherResponse.current.temp_c) °C"
                        
                        for value in self.results{
                            if value.code == weatherResponse.current.condition.code {
                                print(value)
                                
                                self.displaySampleImageForDemo(code: weatherResponse.current.condition.code)
                                self.conditionLabel.text = weatherResponse.current.condition.text

                            }
                        }
                        
                    }
                }
                
            }
            
            //step 4 : start the task
            
            dataTask.resume();
        }
    
    private func getURL (query: String) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "b9852f05b70641a8b13220656220512"
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(apiKey)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return nil
        }
        print(url)
        return URL(string: url)
    }
    
    
    
    private func parseJson(data: Data) -> WeatherResponse?{
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        do {
            weather = try decoder.decode (WeatherResponse.self, from: data)
        } catch {
            print ("Error decoding")
        }
        return weather
    }
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Got location")
        
        if let location = locations.last {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print ("LatLng: (\(latitude), \(longitude))")
            searchText = "\(latitude),\(longitude)"
            loadWeather(search: searchText)
            
        }
        
    }

        func locationManager (_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    
    
    func loadWeatherCondition() {
            guard let url = URL(string: "https://www.weatherapi.com/docs/weather_conditions.json") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode([WeatherConditions1].self, from: data) {
                        DispatchQueue.main.async {
                            self.results = response
                        }
                        return
                    }
                }
            }.resume()
        }
    
}

struct WeatherResponse1: Decodable {
    let location: Location1
    let current: Weather1
}

struct Location1 : Decodable{
    let name: String
}

struct Weather1:Decodable {
let temp_c: Float
    let temp_f: Float
let condition: WeatherCondition1
}

struct WeatherCondition1 : Decodable{
    let text: String
    let code: Int
}

struct WeatherConditions1: Codable {
let code : Int
let day : String
let night : String
}
