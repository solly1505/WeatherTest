//
//  Models.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 26.09.2021.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let main: Main
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int  // облачность в процентах
}

// MARK: - Rain
struct Rain: Codable {
    let lh: Double?  // объем дождя за последний час, мм
    enum CodingKeys: String, CodingKey {
        case lh = "1h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let lh: Double?  // объем снега за последний час, мм
    enum CodingKeys: String, CodingKey {
        case lh = "1h"
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp: Double  //температура в градусах цельсия
    let pressure: Int //атмосферное давление в гПа на уровне моря
    let humidity: Int //влажность в процентах

    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
    }
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?  //скорость ветра метры в секунду
    let deg: Double?    //направление ветра в метереологических градусах
    let gust: Double? //порыв ветра в м/с
}

struct Place: Codable {
    let suggestions: [Suggestion]
}

struct Suggestion: Codable {
    let value, unrestrictedValue: String
    let data: [String: String?]

    enum CodingKeys: String, CodingKey {
        case value
        case unrestrictedValue = "unrestricted_value"
        case data
    }
}

struct CityElement: Codable {
    let source, result, postalCode: String?
    let  geoLat, geoLon: String?
    let qcGeo: Int


    enum CodingKeys: String, CodingKey {
        case source, result
        case postalCode = "postal_code"
        case geoLat = "geo_lat"
        case geoLon = "geo_lon"
        case qcGeo = "qc_geo"
    }
}

typealias City = [CityElement]
