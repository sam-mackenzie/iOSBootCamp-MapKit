//
//  DirectionsViewController.swift
//  MyMap
//
//  Created by Charles Konkol on 2015-05-19.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {

    
    @IBAction func btnback(sender: UIBarButtonItem) {
         self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    @IBOutlet weak var txtRoute: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRoute.text = strroute
        
        // Do any additional setup after loading the view.
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
