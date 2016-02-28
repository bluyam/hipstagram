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
    
    var post: Post? {
        didSet {
            usernameLabel.text = post?.author?.username!
            print(post?.createdAt)
            profileImageView.layer.cornerRadius = 12
            profileImageView.clipsToBounds = true
            
        }
    }
    
}
