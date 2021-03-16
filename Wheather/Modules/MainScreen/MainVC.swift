import CoreLocation
import UIKit
import SkyFloatingLabelTextField

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showWeatherButton: ButtonWithActivityIndicator!
    @IBOutlet private weak var yourLocationCityLabel: UILabel!
    @IBOutlet private weak var weatherInYourLocationCityLabel: UILabel!
    
    // MARK: - Constants
    
    private let titleText = "titleText".localized()
    private let selectedTitleColor = UIColor(red: 32/255, green: 150/255, blue: 96/255, alpha: 1.0)
    private let manager = CLLocationManager()
    
    // MARK: - Variables
    
    private var myLatitude = 0.0
    private var myLongitude = 0.0
    private var cityLatitude = 0.0
    private var cityLongitude = 0.0
    private var yourCurrentCity = ""
    private var model: City?
    
    // MARK: - IBActions

    @IBAction private func tappedCityTextField(_ sender: Any) {

        if cityTextField.text?.isEmpty != nil {
            cityTextField.title = titleText
            cityTextField.selectedTitleColor = selectedTitleColor
        }
    
    }
    
    @IBAction private func tappedShowWeatherButton(_ sender: Any) {
        
        guard let cityName = cityTextField.text, !cityName.isEmpty else {
            showAlert(with: "emptyCityMessage".localized())
            return
        }
        
        if isValidCity(city: cityName) {
            showWeatherButton.startActivityIndicator()
            getCoordinateFrom(address: cityName) { [self] coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                cityLatitude = coordinate.latitude
                cityLongitude = coordinate.longitude
            }
            let paramsForWeatherApi = ["q": cityName, "appid": RequestConstants.appIdForWeatherApi]
            NetworkService.getWeatherInCity(controller: self, url: RequestConstants.urlForWeatherApi, params: paramsForWeatherApi) { [weak self] in
                self?.showWeatherButton.stopActivityIndicator()
                guard let model = $0 else { return }
                self?.showCityTemperature(with: model)
                self?.cityTextField.text = ""
            }
        } else {
            showWeatherButton.stopActivityIndicator()
            cityTextField.title = "errorTitleText".localized()
            cityTextField.selectedTitleColor = .red
        }
    }
    
    @objc func actionTapped(_ sender: UITapGestureRecognizer) {
        if isValidCity(city: yourCurrentCity) {
            getCoordinateFrom(address: yourCurrentCity) { [self] coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                cityLatitude = coordinate.latitude
                cityLongitude = coordinate.longitude
            }
            let paramsForWeatherApi = ["q": yourCurrentCity, "appid": RequestConstants.appIdForWeatherApi]
            NetworkService.getWeatherInCity(controller: self, url: RequestConstants.urlForWeatherApi, params: paramsForWeatherApi) { [weak self] in
                guard let model = $0 else { return }
                self?.showCityTemperature(with: model)
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParameters()
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupParametersForCL()
    }
    
    // MARK: - Logic
    
    private func showCityTemperature(with model: City) {
        let storyboard = UIStoryboard(name: "CityWeather", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "CityWeatherViewController") as? CityWeatherViewController else { return }
        viewController.configure(with: model, myLatitude: myLatitude, myLongitude: myLongitude, cityLatitude: cityLatitude, cityLongitude: cityLongitude)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "errorTitle".localized(), message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "doneButton".localized(), style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    private func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        myLatitude = coordinate.latitude
        myLongitude = coordinate.longitude
        
        let location = CLLocation(latitude: myLatitude, longitude: myLongitude)
        location.geocode { placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                DispatchQueue.main.async {
                    self.yourCurrentCity = placemark.locality ?? "unknown"
                    self.yourLocationCityLabel.text = "yourLocationCityLabel".localized() + self.yourCurrentCity
//                    print(placemark.location)
                    print("city:", self.yourCurrentCity)
                }
            }
        }
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        mapView.setRegion(region, animated: true)
    }
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup
    
    private func setupParameters() {
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(actionTapped))
        weatherInYourLocationCityLabel.isUserInteractionEnabled = true
        weatherInYourLocationCityLabel.addGestureRecognizer(tapAction)
        weatherInYourLocationCityLabel.text = "weatherInYourLocationCityLabel".localized()
        cityTextField.placeholder = "textFieldPlaceholder".localized()
        cityTextField.textAlignment = .center
        cityTextField.delegate = self
        showWeatherButton.layer.cornerRadius = 10
    }
    
    private func setupParametersForCL() {
        manager.desiredAccuracy = kCLLocationAccuracyBest // for battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
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

    // MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {

}
