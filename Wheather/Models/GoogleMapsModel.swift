import Foundation

struct MapPath: Codable {
    var routes: [Route]
}

struct Route: Codable {
    var overview_polyline: OverView
}

struct OverView: Codable {
    var point: String
}
