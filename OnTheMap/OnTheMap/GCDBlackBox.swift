//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(updates  : @escaping() -> Void) {
    DispatchQueue.main.async() {
    updates()
    }
    
}