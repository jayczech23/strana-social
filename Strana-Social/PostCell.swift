//
//  PostCell.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/21/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
        
    }
//----------------------------------------------------------------
    func configureCell(post: Post, image: UIImage? = nil) {
        // set data in cell
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        // attempt to set profile picture from Facebook.
        // get user profile picture
        // function
       // getProfPic(fid: )
        
        
        
        
        // download and cache images
        if image != nil {
            self.postImg.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JAY: Unable to download image from Firebase storage")
                } else {
                    print("JAY: Image downloaded from Firebase storage ")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImg.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString) // keep an eye on this block of code for crashing
                        }
                    }
                }
            })
        }
        
       
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // not 'nil' since it is in Firebase. (same as: if null)
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
            
        })
    }
//----------------------------------------------------------------
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // not 'nil' since it is in Firebase. (same as: if null)
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }

//----------------------------------------------------------------

    
//----------------------------------------------------------------
    
}




