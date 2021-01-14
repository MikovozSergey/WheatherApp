import UIKit
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showWeatherButton: ButtonWithActivityIndicator!
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
        showWeatherButton.startActivityIndicator()
        guard let cityName = cityTextField.text, cityName.isEmpty != true else {
            showWeatherButton.stopActivityIndicator()
            showAlert(with: "Please enter city name")
            return
        }
        
        let city = cityName.isCyrillic ? transliterate(cityName: cityName) : cityName
        
        if isValidCity(city: city) {
            let url = NetworkService.getURL(controller: self, url: RequestConstants.url, predicate: RequestConstants.predicate, cityName: city, appId: RequestConstants.appId)
            NetworkService.getWeatherInCity(controller: self, urlString: url) { [weak self] in
                self?.showWeatherButton.stopActivityIndicator()
                guard let self = self, let model = $0 else { return }
                self.showCityTemperature(with: model)
                self.cityTextField.text = ""
            }
        } else {
            showWeatherButton.stopActivityIndicator()
            cityTextField.title = "wrong city"
            cityTextField.selectedTitleColor = .red
            
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParameters()
        setupKeyboard()
    }
    
    // MARK: - Logic
    
    private func showCityTemperature(with model: City) {
        let storyboard = UIStoryboard(name: "CityWeather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "CityWeatherViewController") as? CityWeatherViewController else { return }
        viewController.configure(with: model)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func transliterate(cityName: String) -> String {
        
        let cyrillicToLatinMap: [Character : String] = [" ":" ", "А":"A", "Б":"B", "В":"V", "Г":"G",
                                                        "Д":"D", "Е":"E", "Ж":"Zh", "З":"Z", "И":"I",
                                                        "Й":"Y", "К":"K", "Л":"L", "М":"M", "Н":"N",
                                                        "О":"O", "П":"P", "Р":"R", "С":"S", "Т":"T",
                                                        "У":"U", "Ф":"F", "Х":"H", "Ц":"Ts", "Ч":"Ch",
                                                        "Ш":"Sh", "Щ":"Sht", "Ю":"Yu", "Я":"Ya",
                                                        "а":"a", "б":"b", "в":"v", "г":"g", "д":"d",
                                                        "е":"e", "ж":"zh", "з":"z", "и":"i", "й":"y",
                                                        "к":"k", "л":"l", "м":"m", "н":"n", "о":"o",
                                                        "п":"p", "р":"r", "с":"s", "т":"t", "у":"u",
                                                        "ф":"f", "х":"h", "ц":"ts", "ч":"ch", "ш":"sh",
                                                        "щ":"sht", "ь":"y", "ю":"yu", "я":"ya"]
        
        if (cityName.isEmpty) {
            return cityName
        } else {
            let characters = Array(cityName)
            var wordInLatin: String = ""
            for char in 0...characters.capacity-1 {
                wordInLatin+=cyrillicToLatinMap[characters[char]]!
            }
            return wordInLatin
        }
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup
    
    private func setupParameters() {
        cityTextField.textAlignment = .center
        cityTextField.delegate = self
    }
    
    private func setupKeyboard() {
        let tappedOnView = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tappedOnView)
    }
    
}

    // MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   
      textField.resignFirstResponder()
      return true
    }
}
