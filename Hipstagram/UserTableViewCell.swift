//
//  UserTableViewCell.swift
//  Hipstagram
//
//  Created by MediaLab on 2/28/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: PFUser? {
        didSet {
            userNameLabel.text = user?.username
            if user!.objectForKey("profile_photo") != nil {
                let profileMedia = user!["profile_photo"]
                profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if imageData != nil {
                        let image = UIImage(data:imageData!)!
                        self.profileImageView.image = image
                    }
                }
            }
            else {
                let image = UIImage(named: "default_profile")
                self.profileImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
