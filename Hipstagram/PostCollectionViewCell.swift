//
//  PostCollectionViewCell.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/26/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet var profileImageView: UIButton!
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var timeSinceLabel: UILabel!
    
    @IBOutlet var captionLabel: UILabel!
    
    var isProfileCell = false
    
    var post: Post? {
        didSet {
            timeSinceLabel.text = Post.convertDateToString((post?.createdAt)!)
            if !isProfileCell {
                self.sendSubviewToBack(profileImageView)
                usernameLabel.text = post?.author?.username!
                profileImageView.layer.cornerRadius = 12
                profileImageView.clipsToBounds = true
                captionLabel.text = post?.caption!
            }
        }
    }
    
}
