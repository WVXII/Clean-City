//
//  ActionViewController.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 18/08/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    
    
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var createEventButton: UIButton!
    
    @IBOutlet weak var joinEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto"{
            //let photoVC = segue.destination as! PhotoViewController
            //photoVC.delegate = self
        }
        
        if segue.identifier == "showMap"{
            //let MapVC = segue.destination as! MapViewController
            //MapVC.delegate = self
        }
        
        if segue.identifier == "showCreateEvent"{
            //let CreateEventVC = segue.destination as! CreateEventViewController
            //CreateEventVC.delegate = self
        }
        
        if segue.identifier == "showJoinEvent"{
            //let JoinEventVC = segue.destination as! JoinEventViewController
            //JoinEventVC.delegate = self
        }
        
    }

}
