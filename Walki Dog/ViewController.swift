//
//  ViewController.swift
//  Walki Dog
//
//  Created by shani herskowitz on 9/20/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        
    }
    
   
    

}

