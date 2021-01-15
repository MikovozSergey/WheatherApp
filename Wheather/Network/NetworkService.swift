import Alamofire
import Foundation

class NetworkService {
    
    static func getURL(url: String, cityName: String, appId: String) -> String {
        return url + cityName + appId
    }
    
    static func getWeatherInCity(controller: MainViewController ,urlString: String, completion: @escaping (City?) -> Void) {
        
        if let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            
            AF.request(url).responseData { response in
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
    
}
