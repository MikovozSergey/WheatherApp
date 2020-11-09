import UIKit
import Alamofire
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: IBOutlets and IBActions
    
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var showWeatherButton: UIButton!
    
    // MARK: private functions
    
    private func showCityTemperature(with model: City) {
        let storyboard = UIStoryboard(name: "CityWeather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "CityWeatherViewController") as? CityWeatherViewController else { return }
        viewController.configure(with: model)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func tapShowWeatherButton() {
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showAlert(with: "Please enter city name")
            return
        }
        let url = getURL(with: cityName)
        cityRequest(urlString: url) { [weak self] in
            guard let self = self, let model = $0 else { return }
            self.showCityTemperature(with: model)
        }
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyles()
    }
    
    // MARK: API
    
    func cityRequest(urlString: String, completion: @escaping (City?) -> Void) {
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let cities = try JSONDecoder().decode(City.self, from: data)
                    completion(cities)
                } catch {
                    self.showAlert(with: "Sorry, weather in this city is not available")
                    completion(nil)
                }
            case let .failure(error):
                self.showAlert(with: "404 erorr = \(error)")
                completion(nil)
            }
        }
    }
    
}

// MARK: Extensions

private extension MainViewController {
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    func applyStyles() {
        navigationItem.title = "Weather in City"
        
        [cityTextField].forEach { // Если у нас используется набор одинаковых элементов
            $0?.textColor = .black
            $0?.textAlignment = .center
            $0?.lineColor = UIColor(red: 116/255, green: 139/255, blue: 174/255, alpha: 1.0)
            $0?.selectedLineColor = .black
            $0?.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
            $0?.placeholder = "Enter a city"
            $0?.placeholderColor = UIColor(red: 116/255, green: 139/255, blue: 174/255, alpha: 1.0)
            $0?.title = "Your city"
        }
        
        showWeatherButton.setTitle("Show weather", for: .normal)
        showWeatherButton.addTarget(self, action: #selector(tapShowWeatherButton), for: .touchDown)
        cityTextField.delegate = self
    }
    
    
    func getURL(with cityName: String) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=302b5b3153622f3d6f42aa61de61076a"
    }
}


extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
