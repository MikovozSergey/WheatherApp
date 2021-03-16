import GoogleMaps
import UIKit

class GoogleMapsViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Variables
    
    private var myLatitude = 0.0
    private var myLongitude = 0.0
    private var cityLatitude = 0.0
    private var cityLongitude = 0.0
    private var model: MapPath?
    
    // MARK: - Constants
    
    // MARK: - IBActions
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Logic
    
    func configure(myLatitude: Double, myLongitude: Double, cityLatitude: Double, cityLongitude: Double) {
//        self.model = model
        self.myLatitude = myLatitude
        self.myLongitude = myLongitude
        self.cityLatitude = cityLatitude
        self.cityLongitude = cityLongitude
        print("МОЯ ШИРОТА: \(myLatitude)  МОЯ ДОЛГОТА: \(myLongitude) \n ШИРОТА ГОРОДА: \(cityLatitude) ДОЛГОТА ГОРОДА: \(cityLongitude)")
    }
    
    private func showRouteonMap() {
        let myCoordinate = "\(myLatitude),\(myLongitude)"
        let myDestination = "\(cityLatitude),\(cityLongitude)"
        let myMode = "driving"
        let params = ["origin": myCoordinate, "destination": myDestination, "mode": myMode, "key": RequestConstants.appIdForGMApi]
        NetworkService.getRoutes(url: RequestConstants.urlForGMApi, params: params) { [weak self] in
            guard let model = $0 else { return }
        
        }

    }
    
    private func setPath(path: GMSPath) {
        var polyline = GMSPolyline.init(path: path)
        polyline.strokeColor = .gray
        polyline.map = self.mapView
        
        var bounds = GMSCoordinateBounds()
        
        for index in 1 ... path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        
        self.mapView.moveCamera(GMSCameraUpdate.fit(bounds))
    }
}
    // MARK: - Setup

//extension GoogleMapsViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
//    }
//}
