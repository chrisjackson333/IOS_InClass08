//
//  ViewController3.swift
//  inClass08
//
//  Created by chris jackson on 6/22/19.
//  Copyright © 2019 Stone, Brian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController3: UIViewController {
    
    var city: String?
    var forecasts = [Forecast]()
    
    let tableView: UITableView = {
        var tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ForecastTableViewCell.self, forCellReuseIdentifier: "CellID")
        tv.register(ForecastHeaderTVCell.self, forCellReuseIdentifier: "HeaderID")
        return tv
    }()
    
    func getForecast(){
        let parameters: Parameters = [
            "APPID": "39eb21bf630dd4303b2452032d841088",
            "q": self.city!
        ]
        AF.request("http://api.openweathermap.org/data/2.5/forecast",
                   method: .get, parameters: parameters).responseJSON { (response) in
                    switch response.result {
                    case let .success(value):
                        let json = JSON(value)
                        print(json)
                        for forecast in json["list"].arrayValue {
                            let tempForecast = Forecast()
                            tempForecast.date = forecast["dt_txt"].stringValue
                            tempForecast.humidity = forecast["main"]["humidity"].stringValue
                            tempForecast.desc = forecast["weather"][0]["description"].stringValue
                            var temp = forecast["main"]["temp"].doubleValue
                            temp = self.kelvinToFahrenheit(temp: temp)
                            tempForecast.temperature = "\(temp)F"
                            var max = forecast["main"]["temp_max"].doubleValue
                            max = self.kelvinToFahrenheit(temp: max)
                            tempForecast.maxTemp = "\(max)F"
                            var min = forecast["main"]["temp_min"].doubleValue
                            min = self.kelvinToFahrenheit(temp: min)
                            tempForecast.minTemp = "\(min)F"
                            self.forecasts.append(tempForecast)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case let .failure(error):
                        print("Failure \(error)")
                    }
                    
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getForecast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        [
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach({ $0.isActive = true })
        tableView.delegate = self
        tableView.dataSource = self
    }
    func kelvinToFahrenheit(temp:Double) -> Double{
        return Double((temp - 273.15) * 1.8 + 32).rounded()
    }
    
}

extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderID", for: indexPath) as! ForecastHeaderTVCell
            cell.label.text = city!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! ForecastTableViewCell
            if forecasts.count > 0 {
                cell.date.text = forecasts[indexPath.row].date!
                cell.humidity.text = "Humidity \(forecasts[indexPath.row].humidity!)%"
                cell.desc.text = forecasts[indexPath.row].desc!
                cell.temperature.text = forecasts[indexPath.row].temperature!
                cell.maxTemp.text = "Max \(forecasts[indexPath.row].maxTemp!)"
                cell.minTemp.text = "Min \(forecasts[indexPath.row].minTemp!)"
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            return 140
        }
        
    }
    
}

class ForecastTableViewCell: UITableViewCell {
    
    var date: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        return label
    }()
    var temperature: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temp"
        return label
    }()
    var maxTemp: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "maxTemp"
        return label
    }()
    var minTemp: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "minTemp"
        return label
    }()
    var humidity: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Humidity"
        return label
    }()
    var desc: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "desc"
        return label
    }()
    
    func setupViews() {
        addSubview(date)
        [
        date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
        date.widthAnchor.constraint(equalToConstant: 220),
        date.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        addSubview(temperature)
        [
        temperature.leftAnchor.constraint(equalTo: date.leftAnchor),
        temperature.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 4),
        temperature.widthAnchor.constraint(equalToConstant: 100),
        temperature.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        addSubview(maxTemp)
        [
        maxTemp.leftAnchor.constraint(equalTo: temperature.rightAnchor, constant: 6),
        maxTemp.centerYAnchor.constraint(equalTo: temperature.centerYAnchor),
        maxTemp.widthAnchor.constraint(equalToConstant: 100),
        maxTemp.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        addSubview(minTemp)
        [
        minTemp.leftAnchor.constraint(equalTo: maxTemp.rightAnchor, constant: 6),
        minTemp.centerYAnchor.constraint(equalTo: temperature.centerYAnchor),
        minTemp.widthAnchor.constraint(equalToConstant: 100),
        minTemp.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        addSubview(humidity)
        [
        humidity.leftAnchor.constraint(equalTo: date.leftAnchor),
        humidity.topAnchor.constraint(equalTo: temperature.bottomAnchor, constant: 4),
        humidity.widthAnchor.constraint(equalToConstant: 200),
        humidity.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        addSubview(desc)
        [
        desc.leftAnchor.constraint(equalTo: date.leftAnchor),
        desc.topAnchor.constraint(equalTo: humidity.bottomAnchor, constant: 4),
        desc.widthAnchor.constraint(equalToConstant: 200),
        desc.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ForecastHeaderTVCell: UITableViewCell {
    
    let label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Header"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        addSubview(label)
        [
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        label.widthAnchor.constraint(equalToConstant: 160),
        label.heightAnchor.constraint(equalToConstant: 30)
        ].forEach({ $0.isActive = true })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Forecast {
    var date: String?
    var humidity: String?
    var temperature: String?
    var maxTemp: String?
    var minTemp: String?
    var desc: String?
}
