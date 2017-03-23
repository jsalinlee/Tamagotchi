//
//  loginViewController.swift
//  Tamagotchi
//
//  Created by Jackie Thind on 3/22/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit
import CoreData

class loginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var petNameTextField: UITextField!
    var userName: String?
    var petName: String?
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        userName = userNameTextField.text!
        petName = petNameTextField.text!
        
        print("Login was Pressed with Username: \(userName!) and Petname: \(petName!)")
    }
}
