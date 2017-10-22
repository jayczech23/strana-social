//
//  DataService.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/22/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

// root database url.
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()  // gs://strana-social.appspot.com 


class DataService {
    
    // singleton class
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("user-profile-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        // user id stored in keychain
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {  //**
        return _REF_PROFILE_IMAGES
    }
    
//-----------------------------------------------------------------
    // create DATABASE user. (not same as authentication user.)
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        // create uid child from users tree.
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
//-----------------------------------------------------------------

}
