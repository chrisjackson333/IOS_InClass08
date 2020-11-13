//
//  ViewController.swift
//  inClass08
//
//  Created by Stone, Brian on 6/19/19.
//  Copyright © 2019 Stone, Brian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
//    var cities = AppData.init()
    let cities = [
        "US":["Charlotte", "Chicago", "New York", "Miami", "San Francisco", "Baltimore", "Houston"],
        "UK":["London", "Bristol", "Cambridge", "Liverpool"],
        "AE":["Abu Dhabi", "Dubai", "Sharjah"],
        "JP":["Tokyo", "Kyoto", "Hashimoto", "Osaka"]
    ]
    
    
    @IBOutlet weak var cityTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tempArr = Array(cities.keys)
        
        return cities[tempArr[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let tempArr = Array(cities.keys)
        cell.textLabel?.text = cities[tempArr[indexPath.section]]![indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tempArr = Array(cities.keys)
        return "\(tempArr[section])"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities.keys.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController2
        let tappedCell = cityTable.cellForRow(at: cityTable.indexPathForSelectedRow!)
        destinationVC.cityName = tappedCell?.textLabel?.text!
        self.cityTable.deselectRow(at: cityTable.indexPathForSelectedRow!, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }


}

