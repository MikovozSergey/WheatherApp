import UIKit

class CityWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var temperatureIcon: UIImageView!
    
    // MARK: - Private variables
    
    private var model: City?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }

    // MARK: - Logic
    
    func configure(with model: City) {
        self.model = model
    }
    
    // MARK: - Setup
    
    private func applyStyle() {
        guard let model = model else { return }
        
        let temperatureInCelsies = round(10 * (model.main.temp - 273.15))/10
        let speedOfWind = model.wind.speed
        
        if temperatureInCelsies < 0 {
            weatherImage.image = UIImage(named: "img-Cold.png")
            temperatureIcon.image = UIImage(named: "ic-temperatureMinus")
        }
        
        temperatureLabel.text = "\(temperatureInCelsies)"
        
        windLabel.text = "Wind in city is equal: \n\(speedOfWind) m/c"
        
        navigationItem.title = model.name
    }
}
