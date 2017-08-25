//
//  UserManager.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    
    let userDefault = UserDefaults.standard
    
    var currentUser: UserObject?
    
    
    //check token in NSUserDefaults
    func isLoggedIn() -> Bool {
        if userDefault.object(forKey: "token") != nil {
            return true
        }
        return false
    }
    
    //set token to NSUserDefaults
    func setToken(token: String) {
        userDefault.set(token, forKey: "token")
    }
    
    //Get token in NSUserDefaults
    func getToken() -> String? {
        if let token = userDefault.object(forKey: "token") as? String {
            return token
        }
        return nil
    }
    
    //Sign out (Delete token in NSUserDefaults)
    func delToken() {
        if let _ = userDefault.object(forKey: "token") as? String {
            userDefault.removeObject(forKey: "token")
        }
    }
}