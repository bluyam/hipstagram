//
//  Post.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/26/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    var author: PFUser?
    var createdAt: NSDate?
    var media: UIImage?
    var caption: String?
    var commentsCount: Int?
    var likesCount: Int?
    var authorImage: UIImage?
    var cachedObject: PFObject?
    
    init(object: PFObject) {
        super.init()
        
        // set data
        author = object["author"] as? PFUser
        createdAt = object.createdAt!
        caption = object["caption"] as? String
        commentsCount = object["commentsCount"] as? Int
        likesCount = object["likesCount"] as? Int
    }

    class func PostsWithArray(array: [PFObject]) -> [Post] {
        var posts = [Post]()
        for object in array {
            posts.append(Post(object: object))
            // when callback complete continue
        }
        return posts
    }
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
     
     /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "Post")
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func postUserProfileImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let user = PFUser.currentUser()!
        user["profile_photo"] = getPFFileFromImage(image)
        user.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
