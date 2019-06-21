import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

	// MARK: - Outlets
	
	@IBOutlet weak var mapView: MKMapView!
    @IBOutlet var details: UIBarButtonItem!
    @IBOutlet var type: UIBarButtonItem!
    @IBOutlet var zoom: UIBarButtonItem!
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
	
	// MARK: - Search
	
	fileprivate var searchController: UISearchController!
	fileprivate var localSearchRequest: MKLocalSearch.Request!
	fileprivate var localSearch: MKLocalSearch!
	fileprivate var localSearchResponse: MKLocalSearch.Response!
	
	// MARK: - Map variables
	
	fileprivate var annotation: MKAnnotation!
	fileprivate var locationManager: CLLocationManager!
	fileprivate var isCurrentLocation: Bool = false
	
	// MARK: - Activity Indicator
	
	fileprivate var activityIndicator: UIActivityIndicatorView!
	
	// MARK: - UIViewController's methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.currentLocationButtonAction(_:)))
		self.navigationItem.leftBarButtonItem = currentLocationButton
		
		let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(ViewController.searchButtonAction(_:)))
		self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.setToolbarHidden(false, animated: false)
		
		mapView.delegate = self
        
        //code to track user current location
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
		
		activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
		activityIndicator.hidesWhenStopped = true
		self.view.addSubview(activityIndicator)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		activityIndicator.center = self.view.center
    }
	
	
	@objc func currentLocationButtonAction(_ sender: UIBarButtonItem) {
        
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        let mylocation = self.mapView.userLocation //edited to simply refer already existing annotation
        let center = CLLocationCoordinate2D(latitude: mylocation.coordinate.latitude, longitude: mylocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
	}
	
	
	@objc func searchButtonAction(_ button: UIBarButtonItem) {
		if searchController == nil {
			searchController = UISearchController(searchResultsController: nil)
		}
		searchController.hidesNavigationBarDuringPresentation = false
		self.searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        matchingItems.removeAll()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if let results = response {
                
                if let err = error {
                    print("Error occurred in search: \(err.localizedDescription)")
                } else if results.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    
                    for item in results.mapItems {
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No Match")")
                        let distance = self.mapView.userLocation.location!.distance(from: item.placemark.location!)/1609.344
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                        print("Distance Away = \(distance) Miles")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
        
	}

	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
	}
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = UIColor.red
        pr.lineWidth = 5
        return pr
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as!
        ResultsTableViewController
        destination.mapItems = self.matchingItems
        destination.myLocation = self.mapView.userLocation.location
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else if mapView.mapType == MKMapType.satellite {
            mapView.mapType = MKMapType.hybrid
        } else {
            mapView.mapType = MKMapType.standard
        }
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        
        if let userLocation = mapView.userLocation.location?.coordinate {
            
            let region = MKCoordinateRegion(
                center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            mapView.setRegion(region, animated: true)
        }
    }
}

