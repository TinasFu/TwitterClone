//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/6/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import Accounts
import Social



class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UIApplicationDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    
   
    var networkController : NetworkController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // day 3 class
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.networkController.fetchHomeTimeLine { (errorDescription : String?, tweets : [Tweet]?) -> (Void) in
            if errorDescription != nil {
                //alert the user that something went wrong
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }



        
        println("Hello")
        
//        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            
//            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
//            tweets!.sort{$1.text > $0.text}
//        //sorted(tweets!) { $1.text > $0.text }
//
//                        
//        }

    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = self.tweets?[indexPath.row]
        
        //tweet?.randomMethod()
        cell.textView.text = tweet?.text
        cell.userImageView?.image = tweet?.avatarImage
        return cell
    }
    
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSingleTweet" {
            let destination = segue.destinationViewController as SingleTweetViewController
            
            let indexPath = self.tableView!.indexPathForSelectedRow()!
            
            //NetworkCall to get new Tweet information.
            let tweet = tweets?[indexPath.row]
            
            destination.tweet = tweet
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    


}
