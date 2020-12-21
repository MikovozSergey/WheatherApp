import UIKit
import Alamofire
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showWeatherButton: UIButton!
    @IBOutlet private weak var annotationLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
    }
    
    // MARK: - Logic
    
    private func showCityTemperature(with model: City) {
        let storyboard = UIStoryboard(name: "CityWeather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "CityWeatherViewController") as? CityWeatherViewController else { return }
        viewController.configure(with: model)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func isSelectedTextField() {
        cityTextField.title = "your city"
        cityTextField.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
    }
    
    @objc private func tapShowWeatherButton() {
        cityTextField.title = "your city"
        cityTextField.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showAlert(with: "Please enter city name")
            return
        }
        if isValidCity(city: cityName) {
            let url = getURL(with: cityName)
            cityRequest(urlString: url) { [weak self] in
                guard let self = self, let model = $0 else { return }
                self.showCityTemperature(with: model)
            }
        } else {
            cityTextField.title = "wrong city"
            cityTextField.selectedTitleColor = .red
        }
    }

    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupTargets() {
        cityTextField.addTarget(self, action: #selector(isSelectedTextField), for: .editingChanged)
        showWeatherButton.addTarget(self, action: #selector(tapShowWeatherButton), for: .touchDown)
        
        cityTextField.textAlignment = .center
        
        cityTextField.delegate = self
    }
    
    // MARK: - API Calls
    
    private func getURL(with cityName: String) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=302b5b3153622f3d6f42aa61de61076a"
    }
    
    private func cityRequest(urlString: String, completion: @escaping (City?) -> Void) {
        
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
            case .failure:
                self.showAlert(with: "Something went wrong, please try again later")
                completion(nil)
            }
        }
    }
    
}

    // MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
