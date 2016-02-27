//
//  HomeViewController.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/26/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post]?
    var postsAsPFObjects: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        // collectionView setup
        collectionView.dataSource = self
        collectionView.delegate = self
        
        makeQuery()

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func makeQuery() {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
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
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts != nil ? posts!.count : 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        cell.post = posts![indexPath.item]
        // we have to query for the image data
        
        // unfortunately, it has too look ugly here to reload the cell properly
        // hopefully I have time to fix this up after I complete more of the project
        let mediaFile = postsAsPFObjects![indexPath.item]["media"] as! PFFile
        mediaFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                let image = UIImage(data:imageData!)
                cell.postImageView.image = image
                cell.post!.media = image
                self.posts![indexPath.item].media = image
                print("this thing is happening")
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // makeQuery()
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
