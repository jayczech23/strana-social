//
//  PostCell.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/21/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
        
        
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        // set data in cell
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
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
    }
}




