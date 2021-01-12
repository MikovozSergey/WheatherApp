import UIKit
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showWeatherButton: UIButton!
    @IBOutlet private weak var annotationLabel: UILabel!
    
    // MARK: - Constants
    
    private let titleText = "your city"
    private let selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
    
    // MARK: - IBActions

    @IBAction private func tappedCityTextField(_ sender: Any) {

        if cityTextField.text?.isEmpty != nil {
            cityTextField.title = titleText
            cityTextField.selectedTitleColor = selectedTitleColor
        }
    
    }
    
    @IBAction private func tappedShowWeatherButton(_ sender: Any) {
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showAlert(with: "Please enter city name")
            return
        }
        if isValidCity(city: cityName) {
            let url = NetworkService.getURL(url: RequestConstants.url, cityName: cityName, appId: RequestConstants.appId)
            NetworkService.getWeatherInCity(controller: self, urlString: url) { [weak self] in
                guard let self = self, let model = $0 else { return }
                self.showCityTemperature(with: model)
                self.cityTextField.text = ""
            }
        } else {
            cityTextField.title = "wrong city"
            cityTextField.selectedTitleColor = .red
            
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParameters()
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
    
    private func setupParameters() {
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
