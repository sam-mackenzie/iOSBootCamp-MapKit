//
//  RouteViewController.swift
//  MapSample
//
//  Created by Chuck Konkol on 5/7/15.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, MKMapViewDelegate ,  CLLocationManagerDelegate {
let locationManagers = CLLocationManager()
    var destination: MKMapItem?
    var pause:Bool = false
    
    @IBOutlet weak var btnPause: UIBarButtonItem!
    @IBAction func btnPause(sender: AnyObject) {
        if pause == false
        {
            pause=true
            btnPause.title = "Resume"
        }
        else
        {
            pause=false
            btnPause.title = "Pause"
        }
        
    }
     let regionRadius: CLLocationDistance = 0.05
    @IBOutlet weak var routeMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     routeMap.showsUserLocation = true
     routeMap.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManagers.delegate = self
            locationManagers.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManagers.startUpdatingLocation()
        }

   
     //centerMapOnLocation(routeMap.userLocation.location)

    }
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
             if pause == false
             {
                self.getDirections()
            }
               
      

            
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
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        // Calling...
     
    }

    func showRoute(response: MKDirectionsResponse) {
        strroute = ""
       
        
        for route in response.routes as! [MKRoute] {
            
            routeMap.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
               
                /// 3.280839895
                var distancelabel:String = ""
                var distance:Double = step.distance / 1609.344
                if distance < 0.1
                {
                    distance = step.distance * 3.280839895
                    distance =  NSString(format: "%.0f", distance).doubleValue
                     distancelabel = "\(distance) feet"
                }
                else
                {
                    distance = step.distance / 1609.344
                    distance =  NSString(format: "%.1f", distance).doubleValue

                     distancelabel = "\(distance) miles"
                }
               
                strroute = strroute + "\n \(distancelabel) \n" + "  \(step.instructions) \n"
                println(strroute)
            }
        }

       
        if let loc = routeMap.userLocation.location {
            
            let region = MKCoordinateRegionMakeWithDistance(
                loc.coordinate, regionRadius, regionRadius)
            routeMap.setRegion(region, animated: true)
            centerMapOnLocation(loc)
        }
     
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius, regionRadius)
        routeMap.setRegion(coordinateRegion, animated: true)
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
