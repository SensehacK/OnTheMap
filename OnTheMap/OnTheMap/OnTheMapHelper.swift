//
//  OnTheMapHelper.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import UIKit




class OnTheMapHelper {
    
    
        func formatURL(url: String) -> String {
            var formattedURL = url
            if formattedURL.characters.first != "h"  && formattedURL.characters.first != "H"{
                formattedURL = "http://\(formattedURL)"
            }
            return String(formattedURL.characters.filter { !" ".characters.contains($0) })
        }
        
    
    
    
    
  class  func sharedInstance() -> OnTheMapHelper {
        struct Singleton {
            static var sharedInstance = OnTheMapHelper()
        }
        return Singleton.sharedInstance
    }
    
    
}

extension UIViewController {
    
    func displayAlertHelper (message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        performUIUpdatesOnMain {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: completionHandler))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func hideKeyboardTapAnwhere () {
        
    }
    
    func dismissKeyboardHelper () {
        view.endEditing(true)
    }
    
}
