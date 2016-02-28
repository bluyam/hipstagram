//
//  ProfileViewController.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/26/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController

class ProfileViewController: UIViewController {
    
    var user: PFUser? {
        didSet {
            if user!.objectForKey("profile_photo") != nil {
                let profileMedia = user!["profile_photo"]
                profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if imageData != nil {
                        let image = UIImage(data:imageData!)
                        // set profile image for view
                        self.profileImageButton.setImage(image, forState: .Normal)
                        print("this thing is happening")
                    }
                }
            }
            else {
                let image = UIImage(named: "default_profile")
                self.profileImageButton.setImage(image, forState: .Normal)
            }
        }
    }

    @IBOutlet var profileImageButton: UIButton!
    
    @IBAction func onProfileImagePressed(sender: AnyObject) {
        // present a camera view
        let croppingEnabled = true
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled) { image in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            if image != nil {
                // save to imageview
                let newSize = CGSize(width: 320, height: 320)
                let resizedImage = Post.resize(image!, newSize: newSize)
                self.profileImageButton.setImage(resizedImage, forState: .Normal)
                Post.postUserProfileImage(resizedImage, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("success changing profile image")
                    }
                    else {
                        print("you were the chosen one")
                    }
                })
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = PFUser.currentUser()
        profileImageButton.imageView?.layer.cornerRadius = 34
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when logout is pressed
        // PFUser.logOut()
    @IBAction func onLogOutPressed(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
