import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Encodable & Decodable {
    let temp: Double
}

struct Weather: Encodable & Decodable {
    let id: Int
    let description: String
}
