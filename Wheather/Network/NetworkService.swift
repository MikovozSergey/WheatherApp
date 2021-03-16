import Alamofire
import Foundation

class NetworkService {
    
//    static func getURL(url: String, cityName: String, appId: String) -> String {
//        return url + cityName + appId
//    }
    // MARK: WITHOUT PARAMETERS
    //    static func getWeatherInCity(controller: MainViewController, url: String, completion: @escaping (City?) -> Void) {
    
    //        if let url = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
    //
    //            AF.request(url).responseData { response in
    //                switch response.result {
    //                case .success:
    //                    do {
    //                        guard let data = response.data else { return }
    //                        let cities = try JSONDecoder().decode(City.self, from: data)
    //                        completion(cities)
    //                    } catch {
    //                        controller.showAlert(with: "notAvailableWeather".localized())
    //                        completion(nil)
    //                    }
    //                case .failure:
    //                    controller.showAlert(with: "errorInApi".localized())
    //                    completion(nil)
    //                }
    //            }
    //
    //        }
    
    static func getWeatherInCity(controller: MainViewController, url: String, params: [String: Any], completion: @escaping (City?) -> Void) {
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let cities = try JSONDecoder().decode(City.self, from: data)
                    completion(cities)
                } catch {
                    controller.showAlert(with: "notAvailableWeather".localized())
                    completion(nil)
                }
            case .failure:
                controller.showAlert(with: "errorInApi".localized())
                completion(nil)
            }
        }
    }
    
    static func getRoutes(url: String, params: [String: Any], completion: @escaping (MapPath?) -> Void) {
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let pathes = try JSONDecoder().decode(MapPath.self, from: data)
                    completion(pathes)
                } catch {
//                    controller.showAlert(with: "notAvailableWeather".localized())
                    completion(nil)
                }
            case .failure:
//                controller.showAlert(with: "errorInApi".localized())
                completion(nil)
            }
        }
    }
}
