import UIKit

class CityWeatherViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    private var model: City?
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    func configure(with model: City) {
        self.model = model
    }
    
    private func applyStyle() {
        guard let model = model else { return }
        temperatureLabel.text = "Temperature in city is equal: \n\(model.main.temp) °C"
        windLabel.text = "Wind in city is equal: \n\(model.wind.speed) m/c"
        
        navigationItem.title = model.name
    }
}
