//
//  ViewController.swift
//  Project 2
//
//  Created by Raman Singh on 2022-11-29.
//

import UIKit
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    var weatherResponseGlobal : WeatherResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        setupMap()
        //addAnnotation (location: getLocation())
    }
    

    @IBAction func onAddLocationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddLocationScreen", sender: self)
        
    }

    
    private func setupMap(){
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                // camera boundaries
                let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: viewRegion)
                mapView.setCameraBoundary(cameraBoundary, animated: true)
                // control zooming
                let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
                mapView.setCameraZoomRange(zoomRange, animated: true)
                mapView.setRegion(viewRegion, animated: true)
                
                loadWeather(location: userLocation)
                
                
            }
        }
    }
    
    
    private func addAnnotation(location: CLLocation,weatherResponse:WeatherResponse) {
        let annotation = MyAnnotation(coordinate: location.coordinate, title: weatherResponse.current.condition.text, subtitle:"Current: \(weatherResponse.current.temp_c) & Feels Like:\(weatherResponse.current.feelslike_c)", glyphText:"\(weatherResponse.current.temp_c)",        code: weatherResponse.current.condition.code
        )
        
        mapView.addAnnotation (annotation)
    }
    
    // load weather api
    func loadWeather(location: CLLocation) {
        
        let search: String? = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
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
                
                
                self.weatherResponseGlobal = weatherResponse
                DispatchQueue.main.async {
                    
                    
                    self.addAnnotation(location:location,weatherResponse:weatherResponse)
                    
                    
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

    
    
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myIdentifier"
        
        var view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        // check to see if we have a view we can reuse
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            // get updated annotation
            dequeuedView.annotation = annotation
            // use our reusable view
            view = dequeuedView
        }
        else{
            
            view.canShowCallout = true
            
            // set the position of the callout
            
            view.calloutOffset = CGPoint(x: 0, y: 10)
            
            // add a button to right side of callout
            
            let button = UIButton (type: .detailDisclosure)
            button.tag = 100
            view.rightCalloutAccessoryView = button
            
            
            
            
            // change colour of accessories
            
            view.tintColor = UIColor.systemRed
            // TODO change colors
            if let myAnnotation = annotation as? MyAnnotation {
                view.glyphText = myAnnotation.glyphText
                // change colour of pin/marker
                
                let numberFormatter = NumberFormatter()
                let number = numberFormatter.number(from: myAnnotation.glyphText ?? "0.0")
                let numberFloatValue = number?.floatValue ?? 0.0
                
                
                if (numberFloatValue >= 35.0) {
                    view.markerTintColor = UIColor.systemRed // dark red
                    
                }else if (numberFloatValue >= 25.0 && numberFloatValue <= 30.0) {
                    view.markerTintColor = UIColor.red
                    
                }else if (numberFloatValue >= 17.0 && numberFloatValue <= 24.0) {
                    view.markerTintColor = UIColor.orange
                    
                }else if (numberFloatValue >= 12.0 && numberFloatValue <= 16.0) {
                    view.markerTintColor = UIColor.blue
                    
                }else if (numberFloatValue >= 0.0 && numberFloatValue <= 11.0) {
                    view.markerTintColor = UIColor.systemBlue
                }
                else if (numberFloatValue < 0.0 ){
                    view.markerTintColor = UIColor.purple
                    
                }
                
                
                // add an image to left side of callout
                
                let weatherImg = displaySampleImageForDemo(code: myAnnotation.code)
                
                let image = UIImage (systemName: weatherImg)
                view.leftCalloutAccessoryView = UIImageView(image: image)
                
            }
            
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print ("Button clicked \(control.tag)")
        performSegue(withIdentifier: "goToDetailScreen", sender: self)
//        guard let coordinates = view.annotation?.coordinate
//        else {
//            return
//        }
//
//
//
//        let launchOptions = [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
//        ]
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates) )
//        mapItem.openInMaps (launchOptions: launchOptions)
    }
    
}

class MyAnnotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var glyphText: String?
    var code: Int
    init (coordinate: CLLocationCoordinate2D, title: String, subtitle: String, glyphText: String? = nil, code:Int)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.glyphText = glyphText
        self.code = code
        super.init()
    }
}

struct WeatherResponse: Decodable {
    let location: Location
    let current: Weather
}

struct Location : Decodable{
    let name: String
}

struct WeatherCondition : Decodable{
    let text: String
    let code: Int
}

struct Weather:Decodable {
    let temp_c: Float
    let temp_f: Float
    let feelslike_c: Float
    
    let condition: WeatherCondition
}

struct WeatherConditionsModel: Codable {
    let code : Int
    let day : String
    let night : String
}
