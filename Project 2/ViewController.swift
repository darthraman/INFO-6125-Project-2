//
//  ViewController.swift
//  Project 2
//
//  Created by Raman Singh on 2022-11-29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onAddLocationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddLocationScreen", sender: self)
        
    }
    
}

