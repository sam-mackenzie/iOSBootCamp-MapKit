//
//  RouteViewController.swift
//  MapSample
//
//  Created by Chuck Konkol on 5/7/15.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, MKMapViewDelegate  {

    var destination: MKMapItem?
    @IBOutlet weak var routeMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     routeMap.showsUserLocation = true
     routeMap.delegate = self
     self.getDirections()


    }

    func getDirections() {

        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination!)
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculateDirectionsWithCompletionHandler({(response: 
            MKDirectionsResponse!, error: NSError!) in

            if error != nil {
                println("Error getting directions")
            } else {
                self.showRoute(response)
            }

        })
    }

    func showRoute(response: MKDirectionsResponse) {

        for route in response.routes as! [MKRoute] {

            routeMap.addOverlay(route.polyline, 
            level: MKOverlayLevel.AboveRoads)

            for step in route.steps {
                println(step.instructions)
            }
        }
        let userLocation = routeMap.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location.coordinate, 2000, 2000)

        routeMap.setRegion(region, animated: true)
    }

    func mapView(mapView: MKMapView!, rendererForOverlay 
        overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
