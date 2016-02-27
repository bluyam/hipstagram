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
    
    var post: Post? {
        didSet {
            if post?.media != nil {
                postImageView.image = post?.media!
            }
        }
    }
    
}
