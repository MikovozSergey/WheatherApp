import UIKit
import Alamofire
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showWeatherButton: UIButton!
    @IBOutlet private weak var annotationLabel: UILabel!
    
    // MARK: - IBActions

    @IBAction private func tapCityTextField(_ sender: Any) {

        if cityTextField.text?.isEmpty != nil {
            cityTextField.placeholder = ""
            cityTextField.title = StyleConstants.titleText
            cityTextField.selectedTitleColor = StyleConstants.selectedTitleColor
        }
    
    }
    
    @IBAction private func tapShowWeatherButton(_ sender: Any) {
        cityTextField.title = StyleConstants.titleText
        cityTextField.selectedTitleColor = StyleConstants.selectedTitleColor
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showAlert(with: "Please enter city name")
            return
        }
        if isValidCity(city: cityName) {
            let url = NetworkService.getURL(url: RequestConstants.url, cityName: cityName, appId: RequestConstants.appId)
            NetworkService.getWeatherInCity(controller: self, urlString: url) { [weak self] in
                guard let self = self, let model = $0 else { return }
                self.showCityTemperature(with: model)
            }
        } else {
            cityTextField.title = "wrong city"
            cityTextField.selectedTitleColor = .red
        }
    }
    
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
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupTargets() {

        cityTextField.textAlignment = .center
        
        cityTextField.delegate = self
    }
    
}

    // MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
