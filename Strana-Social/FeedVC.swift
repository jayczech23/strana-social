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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var captionTextField: FancyField!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var currentUserImg: CircleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var printUser: String!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // set a listener for posts in database.
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
        
            // parse data.
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            
            }
            
            self.tableView.reloadData()
        })
    }
        
//----------------------------------------------------------------
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//----------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
//----------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            //var image: UIImage!
            
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
//----------------------------------------------------------------
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JAY: Remove from keychain? \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: signOutSegue, sender: nil)
        
    }
//----------------------------------------------------------------
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
//----------------------------------------------------------------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            imageSelected = true
            
        } else {
            print("JAY: A valid image wasn't selected.")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
//----------------------------------------------------------------


    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionTextField.text, caption != "" else {
            print("JAY: Caption must be entered.")
            return
        }
        
        guard let image = imageAdd.image, imageSelected == true else {
            print("JAY: An image must be selected.")
            self.displayImageAlert()
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            // unique identifier (random string of characters.)
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("JAY: Unable to upload image to Firebase Storage.")
                } else {
                    print("JAY: Successfully uploaded image to Firebase Storage.")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadUrl {
                    self.postToFirebase(imageUrl: url)
                    }
                }
            }
            
        }
        
    }
    
//----------------------------------------------------------------
    // post user's data to Firebase DATABASE.
    func postToFirebase(imageUrl: String) {
    
        let post: Dictionary<String, AnyObject> = [
            "caption": captionTextField.text! as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject,
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTextField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
    
    }
//----------------------------------------------------------------
    
    func displayImageAlert() -> Void {
        
        let alertController = UIAlertController(title: noImageSelectedTitle, message: noImageSelectedMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

//----------------------------------------------------------------
    @IBAction func currentUserImgTapped(_ sender: Any) {
        
        let alertA = UIAlertController(title: "Profile Picture", message: "Select a profile picture", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertA.addAction(okAction)
        alertA.addAction(cancelAction)
        
        self.present(alertA, animated: true, completion: nil)
        
    }
//----------------------------------------------------------------    
    
    // algorithm to upload and download user profile photo from FIREBASE STORAGE.
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        userPhoto.image = image
//        dismissViewControllerAnimated(true, completion: nil)
//        var data = NSData()
//        data = UIImageJPEGRepresentation(userPhoto.image!, 0.8)!
//        // set upload path
//        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
//        let metaData = FIRStorageMetadata()
//        metaData.contentType = "image/jpg"
//        self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }else{
//                //store downloadURL
//                let downloadURL = metaData!.downloadURL()!.absoluteString
//                //store downloadURL at database
//                self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
//            }
//            
//        }
//    }
    
    // check if user has profile photo or might crash
//    databaseRef.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//    // check if user has photo
//    if snapshot.hasChild("userPhoto"){
//    // set image location
//    let filePath = "\(userID!)/\("userPhoto")"
//    // Assuming a < 10MB file, though you can change that
//    self.storageRef.child(filePath).dataWithMaxSize(10*1024*1024, completion: { (data, error) in
//    
//    let userPhoto = UIImage(data: data!)
//    self.userPhoto.image = userPhoto
//    })
//    }
//    })
    
    
}











