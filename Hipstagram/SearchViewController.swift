//
//  SearchViewController.swift
//  Hipstagram
//
//  Created by MediaLab on 2/28/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var users: [PFUser]?
    
    var DEFAULT_SEARCH_TERM = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // tableView init
        tableView.dataSource = self
        tableView.delegate = self
        
        // style initializations
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.backgroundColor = UIColor.blackColor()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()

        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users != nil ? users!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
        cell.user = users![indexPath.row]
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let currentSearchTerm = searchText.isEmpty ? DEFAULT_SEARCH_TERM : searchText.lowercaseString
            let query = PFUser.query()
            query?.whereKey("username", containsString: currentSearchTerm)
            
            query!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
                if let users = users as? [PFUser] {
                    self.users = users
                    self.tableView.reloadData()
                    print("\(searchText); \(users)")
                }
            }
        }
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
