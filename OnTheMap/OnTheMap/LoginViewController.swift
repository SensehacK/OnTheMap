//
//  ViewController.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {

    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        //Disabled UI
        setUIEnabled(enabled: false)
        
        
        //Get Valid username 
        // Still "@" Valid statement is not been checked.
        guard emailAddressTextField.text != nil && (emailAddressTextField.text?.contains("@"))! else {
            displayAlertHelper(message: "Please Enter a Valid Email Address")
            return
        }
        
        guard passwordTextField.text != nil else {
            displayAlertHelper(message: "Please Enter a Password")
            return
        }
        
        
        
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    
    func setUIEnabled (enabled : Bool) {
        loginButton.isEnabled = enabled
        
        performUIUpdatesOnMain {
            
            // Check whether user Pressed Log in or not Accordingly change the state.
            
            if enabled {
                self.loginButton.setTitle("Login", for: .normal)
            } else {
                self.loginButton.setTitle("Loggin In", for: .disabled)
            }
        }
    }
    
    
    
    func completeLogin() {
       
        performUIUpdatesOnMain {
            let controller =
            self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
            
            self.present(controller, animated: true, completion: nil)
        }
        
    }

}

