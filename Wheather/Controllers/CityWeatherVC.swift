import UIKit

class CityWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets


    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    
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
    
    private func applyStyle() {
        guard let model = model else { return }
        
        let temperatureInCelsies = round(10 * (model.main.temp - 273.15))/10
        let speedOfWind = model.wind.speed
        
        if temperatureInCelsies < 0 {
            weatherImage.image = UIImage(named: "img-Cold.png")
        } else {
            weatherImage.image = UIImage(named: "img-Sun.png")
        }
        
        temperatureLabel.text = "\(temperatureInCelsies)"
        windLabel.text = "Wind in city is equal: \n\(speedOfWind) m/c"
        
        navigationItem.title = model.name
    }
}
