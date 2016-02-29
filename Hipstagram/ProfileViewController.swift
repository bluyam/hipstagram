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
import JGProgressHUD

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var posts: [Post]?
    var postsAsPFObjects: [PFObject]?
    var HUD: JGProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var profileImageButton: UIButton!
    
    var user: PFUser?
    
    // move this to the model
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
                self.HUD.textLabel.text = "Updating..."
                self.HUD.showInView(self.view)
                Post.postUserProfileImage(resizedImage, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("success changing profile image")
                    }
                    else {
                        print("you were the chosen one")
                    }
                    self.HUD.dismiss()
                })
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(backgroundImage)
        
        if user == nil {
            user = PFUser.currentUser()
        }
        else if user?.objectId != PFUser.currentUser()?.objectId {
            logoutButton.alpha = 0
            profileImageButton.userInteractionEnabled = false
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        profileImageButton.imageView?.layer.cornerRadius = 34
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if user!.objectForKey("profile_photo") != nil {
            let profileMedia = user!["profile_photo"]
            self.HUD.textLabel.text = "Loading..."
            self.HUD.showInView(self.view)
            profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    print(image)
                    // set profile image for view
                    self.profileImageButton.setImage(image, forState: .Normal)
                    print("this thing is happening")
                }
                self.HUD.dismiss()
            }
        }
        else {
            let image = UIImage(named: "default_profile")
            self.profileImageButton.setImage(image, forState: .Normal)
        }
        
        makeQuery()
        
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func makeQuery() {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: user!)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        self.HUD.textLabel.text = "Loading..."
        self.HUD.showInView(self.view)
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                // do something with the data fetched
                self.postsAsPFObjects = media
                self.posts = Post.PostsWithArray(media)
                self.collectionView.reloadData()
            } else {
                // handle error
                print("error thingy")
            }
            self.HUD.dismiss()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts != nil ? posts!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        cell.isProfileCell = true
        cell.post = posts![indexPath.item]
        // we have to query for the image data
        
        // get post
        let mediaFile = postsAsPFObjects![indexPath.item]["media"] as! PFFile
        self.HUD.textLabel.text = "Loading..."
        self.HUD.showInView(self.view)
        mediaFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                let image = UIImage(data:imageData!)
                cell.postImageView.image = image
                cell.post!.media = image
                self.posts![indexPath.item].media = image
                print("this thing is happening")
            }
            self.HUD.dismiss()
        }
        
        return cell
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
