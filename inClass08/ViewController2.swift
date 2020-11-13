//
//  ViewController2.swift
//  inClass08
//
//  Created by Stone, Brian on 6/19/19.
//  Copyright © 2019 Stone, Brian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController2: UIViewController {
    var cityName:String?
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cityName!)
        getWeather()
        // Do any additional setup after loading the view.
    }
    @IBAction func forecastBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueToForecast", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToForecast" {
            let vc = segue.destination as! ViewController3
            vc.city = cityName!
        }
    }
    
    func getWeather(){
        let parameters: Parameters = [
            "APPID": "39eb21bf630dd4303b2452032d841088",
            "q": self.cityName!
        ]
        AF.request("http://api.openweathermap.org/data/2.5/weather",
                          method: .get, parameters: parameters).responseJSON { (response) in
                            
                switch response.result {
                    case let .success(value):
                        let json = JSON(value)
                        print(json)
                        print(json["name"].stringValue)
                        let weatherArray =  json["weather"].arrayValue
                        if weatherArray.count > 0 {
                            let weather = weatherArray[0]
                            self.descriptionLabel.text = weather["description"].stringValue
                            print(weather["description"].stringValue)
                        }
                        self.cityLabel.text = self.cityName! + ", " + String(json["sys"]["country"].stringValue)
                        self.humidityLabel.text = String(json["main"]["humidity"].doubleValue) + "%"
                        self.tempMax.text = String(self.kelvinToFahrenheit(temp: json["main"]["temp_max"].doubleValue)) + " F"
                        self.tempMin.text = String(self.kelvinToFahrenheit(temp: json["main"]["temp_min"].doubleValue)) + " F"
                        self.temp.text = String(self.kelvinToFahrenheit(temp: json["main"]["temp"].doubleValue)) + " F"
                        self.windSpeedLabel.text = String(json["wind"]["speed"].doubleValue) + " miles/hr"
                        self.windDegreeLabel.text = String(json["wind"]["degree"].doubleValue) + " degrees"
                        self.cloudinessLabel.text = String(json["clouds"]["all"].intValue) + "%"
                        print(self.kelvinToFahrenheit(temp: 0))
                    case let .failure(error):
                        print("Failure \(error)")
                }
                            
        }
            
        }
    func kelvinToFahrenheit(temp:Double) -> Int{
        return Int((temp - 273.15) * 1.8 + 32)
    }
    }


