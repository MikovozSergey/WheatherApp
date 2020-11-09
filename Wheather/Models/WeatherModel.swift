import Foundation

struct City: Codable {
    var coord: Coord
    var weather: [Wheather]
    var base: String
    var main: Main
    var visibility: Double
    var wind: Wind
    var clouds: Clouds
    //var rain: Rain
    //var snow: Snow
    var dt: Double
    var sys: Sys
    var timezone: Double
    var id: Int
    var name: String
    var cod: Double
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct Wheather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct Wind: Codable {
    var speed: Double
    var deg: Double
}

struct Clouds: Codable {
    var all: Double
}

//struct Rain: Codable {
//    var oneHour: Int
//    var 3h: Int
//}
//
//struct Snow: Codable {
//    var 1h: Int
//    var 3h: Int
//}

struct Sys: Codable {
    var type: Double
    var id: Int
    var country: String
    var sunrise: Double
    var sunset: Double
}
