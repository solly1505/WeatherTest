//
//  SideMenuVC.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 07.10.2021.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableViewAddress: UITableView!
    @IBOutlet weak var fieldAddress: UITextField!
    var citis = [CityElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewAddress.delegate = self
        tableViewAddress.dataSource = self
    }

    @IBAction func tapAddButton(_ sender: Any) {   // Получаем город по координатам
        
        NetworkingManager.getInfoAboutCoord(address: fieldAddress.text!) { city in
            
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Выберите населенный пункт из списка", message: "Если нужного вам населенного пункта нет в списке добавьте район, область, улицу", preferredStyle: .actionSheet)
            city.forEach { cityElement in
                let place = cityElement
                alert.addAction(UIAlertAction(title: place.result, style: .default) { action in
                    self.citis.append(place)
                    self.tableViewAddress.reloadData()
                })
            }
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

            self.present(alert, animated: true)
          }
        }
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = citis[indexPath.row].result
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coordinates = ["latitude":Double(citis[indexPath.row].geoLat!), "longitude":Double(citis[indexPath.row].geoLon!)]
        
        NotificationCenter.default.post(name: .updateMenuTable, object: self, userInfo: coordinates)
        NotificationCenter.default.post(name: .updateNavigationBar, object: self, userInfo: coordinates)
    }
}
