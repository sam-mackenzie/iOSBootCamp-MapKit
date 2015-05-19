//
//  ViewController.swift
//  MapSample
//
//  Created by Chuck Konkol on 5/7/15.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextField!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, 
                    sender: AnyObject?) {

        let destination = segue.destinationViewController as! 
                        ResultsTableViewController

        destination.mapItems = self.matchingItems
    }

    @IBAction func textFieldReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()

    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
            userLocation: MKUserLocation!) {
        mapView.centerCoordinate = userLocation.location.coordinate
    }

    
    @IBAction func zoomIn(sender: AnyObject) {
        let userLocation = mapView.userLocation

        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location.coordinate, 2000, 2000)

        mapView.setRegion(region, animated: true)

    }
    
    @IBAction func changeMaptype(sender: AnyObject) {
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Satellite
        } else {
            mapView.mapType = MKMapType.Standard
        }

    }

    func performSearch() {

        matchingItems.removeAll()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region

        let search = MKLocalSearch(request: request)

        search.startWithCompletionHandler({(response:  
                    MKLocalSearchResponse!,
                                error: NSError!) in

            if error != nil {
                println("Error occured in search: \(error.localizedDescription)")
            } else if response.mapItems.count == 0 {
                println("No matches found")
            } else {
                println("Matches found")

                for item in response.mapItems as! [MKMapItem] {
                    println("Name = \(item.name)")
                    println("Phone = \(item.phoneNumber)")

                    self.matchingItems.append(item as MKMapItem)
                    println("Matching items = \(self.matchingItems.count)")

                    var annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
         })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

