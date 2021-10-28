//
//  ViewController.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 06.07.2021.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    //нужно определять деревни
    //нужно добавить локальную БД
    //нужно нормально ветер выводить
    //нужно 5 дней получать и выводить
    //добавить заглушку если интернета нет
    //обработка ошибок
    
    @IBOutlet weak var tableMenu: UITableView!
    var weatherItem: Weather?
    var locationManager: CLLocationManager = CLLocationManager()
    var loader : UIAlertController?
    @IBOutlet weak var blrView: UIVisualEffectView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
 
        NotificationCenter.default.addObserver(self, selector: #selector(updateBar(_:)), name: .updateNavigationBar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable(_:)), name: .updateMenuTable, object: nil)
        
        DispatchQueue.main.async {
            self.loader = self.startLoader()
            self.locationManager.requestLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationNavigationBar()
        configurationTable()

    }
    
    @objc func postRequest(_ notification: Notification) {
        self.loader = self.startLoader()
        self.locationManager.requestLocation()
    }
    
    @objc func updateBar(_ notification: Notification) {
        //получаем город по координатам
        NetworkingManager.getInfoAboutAddress(lat:notification.userInfo?["latitude"] as! Double,lon:notification.userInfo?["longitude"] as! Double) { place in
            let city = place.suggestions.first?.data["city"]
            dump(city)
            DispatchQueue.main.async {
                self.navigationItem.title = city as! String
            }
        }
    }
    
    @objc func updateTable(_ notification: Notification) {
        //Получаем текущую погоду по координатам
        NetworkingManager.getInfoAboutWeatherNow(lat:notification.userInfo?["latitude"] as! Double,lon:notification.userInfo?["longitude"] as! Double) { weather in
            dump(weather)
            self.weatherItem = weather
              
            DispatchQueue.main.async {
                self.tableMenu.reloadData()
                self.stopLoader(loader: self.loader!)
            }
        }
    }
    
    func configurationNavigationBar()  {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    func doubleToString(value: Double)-> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(for: value) ?? ""
    }
    
    @IBAction func tapLeftButton(_ sender: Any) {
    }
    
    @IBAction func tapRightButton(_ sender: Any) {
        loader = self.startLoader()
        locationManager.requestLocation()
    }
    
    func startLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alert.view.addSubview(indicator)
        self.parent?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader : UIAlertController){
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
           // self.blrView.removeFromSuperview()
            self.blrView.isHidden = true
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    enum SectionsTableMenu: Int {
        case temperature, parameters, explanation, collection
    }
    
    enum RowTableMenu: Int {
        case pressure, humidity, clouds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 3 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch SectionsTableMenu(rawValue: indexPath.section)! {
        case .temperature :
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureTableViewCell", for: indexPath) as! TemperatureTableViewCell
            if  let temperature = weatherItem?.main.temp {
                cell.temperatureLabel.text =  doubleToString(value: temperature)+"\u{2103}"
                cell.explanationLabel.text =  weatherItem?.weather.first?.main}
            return cell
        case .parameters :
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParametersTableViewCell", for: indexPath) as! ParametersTableViewCell
            switch RowTableMenu(rawValue: indexPath.row)! {
            case .pressure:
                cell.titleLabel.text = "pressure"
                if let pressure = weatherItem?.main.pressure {
                    cell.valueLabel.text = String(pressure)}
            case .humidity:
                cell.titleLabel.text = "humidity"
                if let humidity = weatherItem?.main.humidity {
                    cell.valueLabel.text = String(humidity)}
            case .clouds:
                cell.titleLabel.text = "clouds"
                if let clouds = weatherItem?.clouds?.all {
                cell.valueLabel.text = String(clouds)}}
            return cell
        case .explanation :
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExplanationTableViewCell", for: indexPath) as! ExplanationTableViewCell
            if let textWeather = weatherItem?.weather.first?.weatherDescription {
                           cell.valueLabel.text = String(textWeather)}
                       
            // ветер  нормально сделать (направление и всякое)
            if let wind = weatherItem?.wind?.speed {
                cell.valueLabel.text = cell.valueLabel.text! + ". Ветер " + String(wind)}
            if let rain = weatherItem?.rain?.lh {
                cell.valueLabel.text = cell.valueLabel.text! + ". Дождь " + String(rain)}
            if let snow = weatherItem?.snow?.lh {
                cell.valueLabel.text = cell.valueLabel.text! + ". Снег " + String(snow)}
            return cell
        case .collection :
            let cell = tableView.dequeueReusableCell(withIdentifier:  "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 60 : (tableMenu.bounds.height - 3*70)/3
    }
    
    func configurationTable() {
        tableMenu.delegate = self
        tableMenu.dataSource = self
        
        ["TemperatureTableViewCell", "ParametersTableViewCell", "ExplanationTableViewCell", "CollectionTableViewCell"].forEach { nameCell in
            tableMenu.register(UINib(nibName: nameCell, bundle: nil), forCellReuseIdentifier: nameCell)
        }
    }
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }
         
        let coordinates = ["latitude":last.coordinate.latitude, "longitude":last.coordinate.longitude]
        
        NotificationCenter.default.post(name: .updateMenuTable, object: self, userInfo: coordinates)
        NotificationCenter.default.post(name: .updateNavigationBar, object: self, userInfo: coordinates)
    }
}

extension Notification.Name {
    static let updateNavigationBar = Notification.Name("updateNavigationBar")
    static let updateMenuTable = Notification.Name("updateMenuTable")
}
