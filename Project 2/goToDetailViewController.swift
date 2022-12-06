//
//  goToDetailViewController.swift
//  Project 2
//
//  Created by Raman Singh on 2022-12-05.
//

import UIKit

class goToDetailViewController: UIViewController {
    
    var lat: String = ""
    var long: String = ""
    
    @IBOutlet weak var weatherImg: UIImageView!
    
    @IBOutlet weak var locLabel: UITextField!
    
    @IBOutlet weak var tempratuteLabel: UITextField!
    
    @IBOutlet weak var weatherConditionLabel: UITextField!
    
    @IBOutlet weak var highLowTempLabel: UITextField!
    
    var myArr:[ForecastDayDS] = []

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lat \(lat) and long \(long)")
        // calling api
        loadWeatherApi(latitude: lat, longitude: long, days: 1)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackPress(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func loadWeatherApi(latitude:String,longitude:String,days:Int) {
        
        let search: String? = "\(latitude),\(longitude)"
        
        guard let search = search else {
            return
        }
        // Step 1: Get URL
        guard let url = getURL (query: search,days: days) else {
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
                
                
                DispatchQueue.main.async {
                    
                    self.locLabel.text = weatherResponse.location.name
                    self.weatherConditionLabel.text = weatherResponse.current.condition.text
                    self.tempratuteLabel.text = "\(weatherResponse.current.temp_c) °C"
                    self.highLowTempLabel.text = "High Temp: \(weatherResponse.forecast.forecastday[0].day.maxtemp_c) °C & Low Temp: \(weatherResponse.forecast.forecastday[0].day.mintemp_c) °C"
                    
                    let config = UIImage.SymbolConfiguration (paletteColors: [
                        .systemRed,
                        .systemYellow
                    ])
                    self.weatherImg.preferredSymbolConfiguration=config
                    let systemImageString: String = self.displaySampleImageForDemo(code: weatherResponse.current.condition.code)
                    self.weatherImg.image = UIImage(systemName:systemImageString)
                    
                }
                
                self.loadWeatherForecastApi(latitude: latitude, longitude: longitude, days: 10)
                
            }
            
        }
        
        //step 4 : start the task
        
        dataTask.resume();
        
    }
    
    private func displaySampleImageForDemo(code: Int)-> String {
    
        var imageStr : String = ""

        
        print(code)
        
        if code == 1000 {
            imageStr =  "sun.max"
        }else if code == 1003{
            imageStr = "cloud.sun.circle.fill"

        }else if code == 1006{
            imageStr = "cloud.sun"

        }else if code == 1009{
            imageStr = "cloud"

        }else if code == 1030{
            imageStr = "smoke.fill"

        }else if code == 1063{
            imageStr = "cloud.sun.rain.circle"

        }else if code == 1066{
            imageStr = "cloud.snow"

        }else if code == 1069{
            imageStr = "cloud.sleet"

        }else if code == 1072{
            imageStr = "cloud.drizzle.circle.fill"

        }else if code == 1087{
            imageStr = "cloud.bolt.rain"

        }else if code == 1114{
            imageStr = "cloud.snow"

        }else if code == 1117{
            imageStr = "cloud.rain.circle"

        }else if code == 1135{
            imageStr = "cloud.fog"

        }else if code == 1147{
            imageStr = "cloud.fog"

        }else if code == 1150{
            imageStr = "cloud.sun.rain.fill"

        }else if code == 1153{
            imageStr = "cloud.sun.rain.fill"

        }else if code == 1168{
            imageStr = "cloud.snow.circle"

        }else if code == 1171{
            imageStr = "cloud.sleet"

        }else if code == 1180{
            imageStr = "cloud.sun.rain"

        }else if code == 1183{
            imageStr = "cloud.rain"

        }else if code == 1186{
            imageStr = "cloud.sun.rain.circle"

        }else if code == 1189 || code == 1192 || code == 1195{
            imageStr = "cloud.rain.circle.fill"

        }else if code == 1198{
            imageStr = "cloud.snow.circle"

        }else if code == 1201{
            imageStr = "cloud.snow.fill"

        }else if code == 1204 || code == 1207{
            imageStr = "cloud.sleet"

        }else if code == 1210 || code == 1213 || code == 1216 || code == 1219 || code == 1222 || code == 1225 || code == 1237 || code == 1255 || code == 1258 || code == 1261 || code == 1264{
            imageStr = "snowflake.circle"

        }else if code == 1240 || code == 1243 || code == 1246 || code == 1249 || code == 1252 {
            imageStr = "cloud.rain.fill"
        }
        else if code == 1273 || code == 1276  {
            imageStr = "cloud.bolt.rain"

        }
        else if code == 1279 || code == 1282  {
            imageStr = "cloud.snow.fill"

        }else{
            imageStr = "sun.max.trianglebadge.exclamationmark"
        }
        
        return imageStr
        
    }

    
    // load weather api
    func loadWeatherForecastApi(latitude:String,longitude:String,days:Int) {
        
        let search: String? = "\(latitude),\(longitude)"
        
        guard let search = search else {
            return
        }
        // Step 1: Get URL
        guard let url = getURL (query: search,days: days) else {
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
                
                self.myArr = weatherResponse.forecast.forecastday
                DispatchQueue.main.async {
                    self.tableView.dataSource = self
                }
                
                
            }
            
        }
        
        //step 4 : start the task
        
        dataTask.resume();
        
    }
    
    private func getURL (query: String,days: Int) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "forecast.json"
        let apiKey = "b9852f05b70641a8b13220656220512"
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(apiKey)&q=\(query)&days=\(days)&aqi=no&alerts=no"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return nil
        }
        print(url)
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponseDS?{
        let decoder = JSONDecoder()
        var weather: WeatherResponseDS?
        do {
            weather = try decoder.decode (WeatherResponseDS.self, from: data)
        } catch {
            print ("Error decoding")
        }
        return weather
    }
    
}
    extension goToDetailViewController : UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myArr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell",for: indexPath)
            
            let item = myArr[indexPath.row]

            var content = cell.defaultContentConfiguration()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEEE"

            if let date = dateFormatter.date(from: item.date) {
                content.text = dateFormatterPrint.string(from: date)

            } else {
               print("There was an error decoding the string")
            }
            
            content.secondaryText = "\(item.day.avgtemp_c) C°"
            
            let systemImg: String = self.displaySampleImageForDemo(code: item.day.condition.code)
            
            content.image = UIImage(systemName: systemImg)
            
            cell.contentConfiguration = content
            
            return cell
        }
        
        
    }

    struct WeatherResponseDS: Decodable {
        let location: Location
        let current: Weather
        let forecast:ForecastDS
    }

    struct WeatherDS:Decodable {
        let temp_c: Float
        let temp_f: Float
        let feelslike_c: Float
        
        let condition: WeatherCondition
    }

    struct WeatherConditionDS: Decodable{
        let text: String
        let code: Int
    }

    struct LocationDS : Decodable{
        let name: String
    }

    struct ForecastDS : Decodable{
        let forecastday : [ForecastDayDS]
    }

    struct ForecastDayDS : Decodable{
        let date: String
        let day : DayObject
    }

    struct DayObject: Decodable {
        let maxtemp_c: Float
        let mintemp_c: Float
        let avgtemp_c :Float
        let condition : WeatherConditionDS
    }



