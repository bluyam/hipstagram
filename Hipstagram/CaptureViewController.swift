//
//  CaptureViewController.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/26/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import ALCameraViewController
import JGProgressHUD

class CaptureViewController: UIViewController {

    var postPreviewImage: UIImage!
    var caption: String!
    var HUD = JGProgressHUD(style: .Dark)
    
    @IBOutlet var captionField: UITextField!
    
    @IBOutlet var postPreviewImageView: UIImageView!
    
    @IBAction func onAddImagePressed(sender: AnyObject) {
        let croppingEnabled = true
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled) { image in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            if image != nil {
                // save to imageview
                let newSize = CGSize(width: 320, height: 320)
                self.postPreviewImage = Post.resize(image!, newSize: newSize)
                self.postPreviewImageView.image = self.postPreviewImage
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        if postPreviewImage != nil {
            self.HUD.textLabel.text = "Posting..."
            self.HUD.showInView(self.view)
            Post.postUserImage(postPreviewImage, withCaption: captionField.text ?? "") { (flag: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Image Posted Successfully!")
                }
                else {
                    print("error occurred \(error?.localizedDescription)")
                }
                self.HUD.dismiss()
            }
        }
        else {
            let alertController = UIAlertController(title: "Whoops", message: "Please choose an image before posting.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Alright.", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
