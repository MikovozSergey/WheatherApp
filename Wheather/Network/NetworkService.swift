import Alamofire
import Foundation

class NetworkService {
    
    static func getURL(controller: MainViewController, url: String, predicate: String, cityName: String, appId: String) -> String {
        
        let spaceBetweenWords = " "
        let hyphenBetweenWords = "-"
        
        if cityName.contains(spaceBetweenWords) || cityName.contains(hyphenBetweenWords) {
            let fullCity = cityName.components(separatedBy: [" ", "-"])
            let countOfSpaces = fullCity.count - 1
            if countOfSpaces >= 2 {
                controller.showAlert(with: "Please, write a correct city")
            }
            let firstPartOfCity = fullCity[0]
            let secondPartOfCity = fullCity[1]
            
            return url + firstPartOfCity + predicate + secondPartOfCity + appId
        } else {
            return url + cityName + appId
        }
    }
    
    static func getWeatherInCity(controller: MainViewController ,urlString: String, completion: @escaping (City?) -> Void) {
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let cities = try JSONDecoder().decode(City.self, from: data)
                    completion(cities)
                } catch {
                    controller.showAlert(with: "Sorry, weather in this city is not available")
                    completion(nil)
                }
            case .failure:
                controller.showAlert(with: "Something went wrong, please try again later")
                completion(nil)
            }
        }
    }

}
