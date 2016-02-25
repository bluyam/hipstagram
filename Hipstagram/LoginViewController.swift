//
//  LoginViewController.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/24/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    @IBAction func textBoxDeselected(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!) { (user:PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Login successful!")
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
            }
            else {
                print("Login unsuccessful: \(error!.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("We created a user!")
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
            }
            else {
                print("Failed to create a user: \(error!.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // set status bar appearance
        self.setNeedsStatusBarAppearanceUpdate()
        
        // set background image to background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "land")!)
        
        // styling text fields and placeholders
        let usernameBorder = CALayer()
        let uwidth = CGFloat(1)
        usernameBorder.borderColor = UIColor.lightGrayColor().CGColor
        usernameBorder.frame = CGRect(x: 0, y: userNameField.frame.size.height - uwidth, width:  userNameField.frame.size.width, height: userNameField.frame.size.height)
        
        usernameBorder.borderWidth = uwidth
        userNameField.layer.addSublayer(usernameBorder)
        userNameField.layer.masksToBounds = true
        
        let passwordBorder = CALayer()
        let pwidth = CGFloat(1)
        passwordBorder.borderColor = UIColor.lightGrayColor().CGColor
        passwordBorder.frame = CGRect(x: 0, y: userNameField.frame.size.height - pwidth, width:  userNameField.frame.size.width, height: userNameField.frame.size.height)
        
        passwordBorder.borderWidth = pwidth
        passwordField.layer.addSublayer(passwordBorder)
        passwordField.layer.masksToBounds = true
        
        let usernamePlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        userNameField.attributedPlaceholder = usernamePlaceholder
        
        let passwordPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        passwordField.attributedPlaceholder = passwordPlaceholder
        
        // styling sign in button
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
