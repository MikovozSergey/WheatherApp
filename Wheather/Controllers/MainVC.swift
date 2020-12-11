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
        setupUI()
    }
    
    // MARK: - Logic
    
    private func showCityTemperature(with model: City) {
        let storyboard = UIStoryboard(name: "CityWeather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "CityWeatherViewController") as? CityWeatherViewController else { return }
        viewController.configure(with: model)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func isSelectedTextField() {
        guard let cityName = cityTextField.text else { return }
        if cityName == "" {
            cityTextField.title = "your city"
            cityTextField.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
        }
    }
    
    @objc private func tapShowWeatherButton() {
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showAlert(with: "Please enter city name")
            return
        }
        if isValidCity(city: cityName) {
            cityTextField.title = "your city"
            cityTextField.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
            let url = getURL(with: cityName)
            cityRequest(urlString: url) { [weak self] in
                guard let self = self, let model = $0 else { return }
                self.showCityTemperature(with: model)
            }
        } else {
            cityTextField.title = "wrong city"
            cityTextField.selectedTitleColor = .red
        }
        cityTextField.text = ""
    }
    
    // MARK: - API Calls
    
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
                self.showAlert(with: "Something whent wrong, please try again later")
                completion(nil)
            }
        }
    }
    
}

    // MARK: - Extensions

private extension MainViewController {
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - Setup
    
    func setupUI() {
        navigationItem.title = "WEATHER IN CITY"
        
        annotationLabel.text = "The city name must be written in English and contain from 2 to 18 characters. The city should not contain spaces, numbers."
        
        cityTextField.textColor = .black
        cityTextField.textAlignment = .center
        cityTextField.lineColor = UIColor(red: 116/255, green: 139/255, blue: 174/255, alpha: 1.0)
        cityTextField.title = "Your city"
        cityTextField.selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
        cityTextField.placeholder = "Enter a city"
        cityTextField.placeholderColor = UIColor(red: 116/255, green: 139/255, blue: 174/255, alpha: 1.0)
        cityTextField.addTarget(self, action: #selector(isSelectedTextField), for: .editingChanged)

        showWeatherButton.setTitle("SHOW WEATHER", for: .normal)
        showWeatherButton.addTarget(self, action: #selector(tapShowWeatherButton), for: .touchDown)
        cityTextField.delegate = self
    }
    
    // MARK: - Api Calls
    
    func getURL(with cityName: String) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=302b5b3153622f3d6f42aa61de61076a"
    }
}

    // MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
