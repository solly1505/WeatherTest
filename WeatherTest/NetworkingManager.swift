//
//  NetworkingManager.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 26.09.2021.
//

import Foundation

class  NetworkingManager {
    static func getInfoAboutWeatherNow(lat:Double, lon:Double, comletion: @escaping (_ response: Weather)->()){
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=a16ff150d11b063896ac814ddf3f6208&units=metric") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: data)
                comletion(weather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func getInfoAboutAddress(lat:Double, lon:Double, comletion: @escaping (_ response: Place)->()){
        guard let url = URL(string:"https://suggestions.dadata.ru/suggestions/api/4_1/rs/geolocate/address?lat=\(lat)&lon=\(lon)") else { return }
        var request = URLRequest(url: url)
        request.addValue("Token c2b9a02a50669ca094f2ca9a1d9d10ae93c8d13b", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let place = try decoder.decode(Place.self, from: data)
                comletion(place)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func getInfoAboutCoord(address:String, comletion: @escaping (_ response: City)->()){
        guard let url = URL(string:"https://cleaner.dadata.ru/api/v1/clean/address") else { return }
        var request = URLRequest(url: url)
        request.addValue("Token c2b9a02a50669ca094f2ca9a1d9d10ae93c8d13b", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("db0df5ba24a4cd29f0ef89a836414f2329174170", forHTTPHeaderField: "X-Secret")
        request.httpMethod = "POST"
      //  let values = ["Правда Речная 27"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: [address])
        
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let city = try decoder.decode(City.self, from: data)
                comletion(city)
            } catch {
                print(error)
            }
        }.resume()
    }
}
