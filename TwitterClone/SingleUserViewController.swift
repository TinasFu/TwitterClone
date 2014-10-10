//
//  SingleUserViewController.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/9/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
//import Accounts
//import Social

class SingleUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabelView: UILabel!
    
    var tweet : Tweet!
    var tweets : [Tweet]?
//    var twitterAccount : ACAccount?
    var networkController : NetworkController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.networkController.fetchUserTimeLine(self.tweet, completionHandler: { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                //alert the user that something went wrong
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }

        })
        
        self.userProfileImageView?.image = self.tweet.avatarImage
        self.userNameLabelView.text = self.tweet.userName
        
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //step 1 dequeue the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        
        //step 2 figure out which model object youre going to use to configure the cell
        //this is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        
        
        cell.textView.text = tweet?.text
        if tweet?.avatarImage != nil{
            cell.userImageView?.image = tweet?.avatarImage
        } else {
            
            self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath)
                cell.userImageView?.image = image
            })
            
        }
        //cell.userImageView?.image = tweet?.avatarImage
        return cell
    }

    
    
    



}
