import UIKit
import UIKit
import MapKit
import CoreLocation

class ResultsTableViewController: UITableViewController {

    var mapItems: [MKMapItem]?
    var myLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func viewConfigurations() {
        tableView.register(UINib.init(nibName: "ResultsTableCell", bundle: nil), forCellReuseIdentifier: "result_cell")
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "resultCell", for: indexPath) as! ResultsTableCell

        let row = indexPath.row
        
        if let item = mapItems?[row] {
            cell.nameLabel.text = item.name
            let distance = self.myLocation.distance(from: item.placemark.location!)/1609.344
            let str_distance = String(distance) + " Miles"
            cell.phoneLabel.text = str_distance
            
            cell.openInMAp = {
                let regionSpan = MKCoordinateRegion(center: item.placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let mapItem = MKMapItem(placemark: item.placemark)
                mapItem.name = item.placemark.name
                mapItem.openInMaps(launchOptions: options)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let routeViewController = segue.destination
            as! RouteViewController
        if let indexPath = self.tableView.indexPathForSelectedRow,
            let destination = mapItems?[indexPath.row] {
            routeViewController.destination = destination
        }
    }
}
