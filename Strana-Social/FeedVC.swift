//
//  FeedVC.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/16/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // set a listener for posts in database.
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
        
            print("JAY: \(snapshot.value)")
            
        })
        
    }
//----------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//----------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
//----------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
//----------------------------------------------------------------
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JAY: Remove from keychain? \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: signOutSegue, sender: nil)
        
    }
//----------------------------------------------------------------
    
}
