import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var routeMap: MKMapView!
    var destination: MKMapItem?
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeMap.delegate = self
        routeMap.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        self.getDirections()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getDirections() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        
        if let destination = destination {
            request.destination = destination
            //adding annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = destination.placemark.coordinate
            annotation.title = destination.name
            self.routeMap.addAnnotation(annotation)
            
        }
        
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let response = response {
                    self.showRoute(response)
                }
            }
        })
    }
    
    func showRoute(_ response: MKDirections.Response) {
        
        for route in response.routes {
            routeMap.addOverlay(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
        
        if let coordinate = userLocation?.coordinate {
            let region =
                MKCoordinateRegion(center: coordinate,
                                   latitudinalMeters: 2000, longitudinalMeters: 2000)
            routeMap.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}
