//
//  ViewController.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {

    // Outlets 
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    // Activated the property "Secure Text Entry" so that we can enter the password securely. Thanks for the Suggestion
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // Login Button Actions
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        //Disabled UI
        setUIEnabled(enabled: false)
        
        //Get Valid username 
        // Still "@" Valid statement is not been checked.
        guard emailAddressTextField.text != nil && (emailAddressTextField.text?.contains("@"))! else {
            displayAlertHelper(message: "Please Enter a Valid Email Address")
            return
        }
        // Guard Password is Not Empty.
        guard passwordTextField.text != nil else {
            displayAlertHelper(message: "Please Enter a Password")
            return
        }
        
        //Network Activity visible
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // MARK: Log in  Get User Session ID
        
        UdacityClientConvenience.sharedInstance().getUserSessionKey(username: emailAddressTextField.text!, password: passwordTextField.text!) { (userSessionKey , error) in
            
            // Userkey returns value which means it passed success
            if let userSessionKey = userSessionKey {
                // Verify User Session key with Udacity
                
                UdacityClientConvenience.sharedInstance().identifyUserWithSessionKey(userSessionKey: userSessionKey) { (success, error ) in
                    
                    // Check back returned value by completion handler of Identify USer SEssion Key method
                    if success! {
                        self.completeLogin()
                    } else {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        print("Error Couldn't identify the Session Key of USer")
                        self.displayAlertHelper(message: error!)
                    }
                }
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                //Enable the UI , Print some logs for Console Debugging & Display the error.
                self.setUIEnabled(enabled: true)
                print("Coudln't Find User Key in get User Session Method of Login button Pressed Action ")
                self.displayAlertHelper(message: error!)
            }
            
        }
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        displayAlertHelper(message: "Please Sign up at https://www.udacity.com/account/auth#!/signup")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Hide keyboard when return key is pressed and perform submit action
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        loginButton.sendActions(for: .touchUpInside)
        return false
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Console Debug Prints
        print("In func Complete Login of LoginViewController ")
        
       
        performUIUpdatesOnMain {
            let controller =
            self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
            
            // Console Debug Prints
            print("In func Complete Login in Perform UI Updates on Main of LoginViewController ")
            
            self.present(controller, animated: true, completion: nil)
        }
        
    }

}

