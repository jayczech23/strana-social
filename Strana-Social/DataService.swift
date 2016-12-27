//
//  DataService.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/22/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import Foundation
import Firebase

// root database url.
let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
    // singleton class
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
//-----------------------------------------------------------------
    // create DATABASE user. (not same as authentication user.)
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        // create uid child from users tree.
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
//-----------------------------------------------------------------

    












//-----------------------------------------------------------------
}
