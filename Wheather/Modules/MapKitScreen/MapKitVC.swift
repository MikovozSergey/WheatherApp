import MapKit
import UIKit

class MapKitViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private var myLatitude = 0.0
    private var myLongitude = 0.0
    private var cityLatitude = 0.0
    private var cityLongitude = 0.0
    
    // MARK: - IBActions
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        aplyStyle()
        configureRouteForMapView()
    }
    
    // MARK: - Logic
    
    func configure(myLatitude: Double, myLongitude: Double, cityLatitude: Double, cityLongitude: Double) {
        self.myLatitude = myLatitude
        self.myLongitude = myLongitude
        self.cityLatitude = cityLatitude
        self.cityLongitude = cityLongitude
        print("МОЯ ШИРОТА: \(myLatitude)  МОЯ ДОЛГОТА: \(myLongitude) \n ШИРОТА ГОРОДА: \(cityLatitude) ДОЛГОТА ГОРОДА: \(cityLongitude)")
    }
    
    private func configureRouteForMapView() {
        
        mapView.delegate = self
        
        let sourceLocation = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: cityLatitude, longitude: cityLongitude)
                
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Your location"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Location of city with weather"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)

        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
    }
    
}

    // MARK: - MKMapViewDelegate

extension MapKitViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .gray
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
