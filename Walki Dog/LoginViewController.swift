//
//  LoginViewController.swift
//  Walki Dog
//
//  Created by shani herskowitz on 9/23/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func login(_ sender: Any) {
        guard let email = username.text else {return}
        guard let password = password.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                self.navigationController?.popViewController(animated: true)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
