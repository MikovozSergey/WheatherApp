import UIKit

class CityWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var temperatureIcon: UIImageView!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var temperatureStack: UIStackView!
    
    @IBOutlet private weak var windLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var windLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var temperatureStackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var temperatureStackTrailingConstraint: NSLayoutConstraint!
    
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
            showSnow()
        } else {
            showRippleOfSun(currentController: self)
        }
        
        temperatureLabel.text = "\(temperatureInCelsies)"
        windLabel.text = "Wind in city is equal: \n\(speedOfWind) m/c"
        
        showRunningLine()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = model.name
        
    }
    
    // Done. Поизучав эту тему, лучше использовать испускание частиц.
    private func showSnow() {
        weatherImage.image = UIImage(named: "imgCold.png")
        temperatureIcon.image = UIImage(named: "icTemperatureMinus")

        let flakeEmitterCell = CAEmitterCell()
        flakeEmitterCell.contents = UIImage(named: "imgSnejinka")?.cgImage
        flakeEmitterCell.emissionRange = .pi
        flakeEmitterCell.lifetime = 20.0
        flakeEmitterCell.birthRate = 3
        flakeEmitterCell.scale = 0.15
        flakeEmitterCell.scaleRange = 0.6
        flakeEmitterCell.velocity = -30.0
        flakeEmitterCell.velocityRange = -20
        flakeEmitterCell.spin = -0.5
        flakeEmitterCell.spinRange = 1.0
        flakeEmitterCell.yAcceleration = 30.0
        flakeEmitterCell.xAcceleration = 5.0

        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 10
        snowEmitterLayer.emitterCells = [flakeEmitterCell]

        view.layer.addSublayer(snowEmitterLayer)
    }
    
    // DONE
    private func showRippleOfSun(currentController: UIViewController) {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.weatherImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
    // Много способов, ни один не работает как нужно, библиотека MarqueeLabel, конфликт IB  Designable
    private func showRunningLine() {
//        self.windLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
//        self.windLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
//        temperatureStack.frame.origin.x -= temperatureStack.frame.size.width * 2
//        windLabel.center = CGPoint(x: 0 - windLabel.frame.size.width / 2, y: self.windLabel.center.y)
        self.windLabelLeadingConstraint.isActive = true
        self.temperatureStackLeadingConstraint.isActive = true
        UIView.animate(withDuration: 3, delay: 0, options: .repeat,  animations: {() -> Void in
            
            self.windLabelLeadingConstraint.isActive = false
            self.temperatureStackLeadingConstraint.isActive = false
            self.windLabelTrailingConstraint.isActive = true
            self.temperatureStackTrailingConstraint.isActive = true
            
            self.temperatureStack.frame.origin.x = self.view.frame.width
            self.windLabel.frame.origin.x = self.view.frame.width
        })
    }
}
