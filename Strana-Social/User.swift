//
//  User.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/29/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    private var _profileImageUrl: String!
    private var _userID: String!
    private var _userRef: FIRDatabaseReference!
    
    var profileImageUrl: String {
        return _profileImageUrl
    }
    
    var userID: String {
        return _userID
    }
//-----------------------------------------------------------------
    
    init(imageUrl: String) {
        self._profileImageUrl = imageUrl
    }
//-----------------------------------------------------------------
    
    // parse data given 'User key'
    init(userID: String, userData: Dictionary<String, AnyObject>) {
        
        self._userID = userID
        
        if let profileImageUrl = userData["userImageUrl"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        
        _userRef = DataService.ds.REF_USER_CURRENT.child(_userID)
        
    }
//-----------------------------------------------------------------

}
