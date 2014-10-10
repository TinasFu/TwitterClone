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



class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    
   
    var networkController : NetworkController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register TweetCell.xib, set indentifier to "TWEET_CELL" which we use later in tableview func
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")

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



        
//        println("Hello")
        
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
        
        //step 1 dequeue the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        
        //step 2 figure out which model object youre going to use to configure the cell
        //this is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        
        //tweet?.randomMethod()
        
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
    
    
    //MARK: Segue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowSingleTweet" {
//            let destination = segue.destinationViewController as SingleTweetViewController
//            
//            let indexPath = self.tableView!.indexPathForSelectedRow()!
//            
//            //NetworkCall to get new Tweet information.
//            let tweet = tweets?[indexPath.row]
//            
//            destination.tweet = tweet
//            
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tweet = self.tweets?[indexPath.row]
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SINGLETWEET") as SingleTweetViewController
        
        destinationVC.tweet = tweet
        //Give the VC your data you want to pass it.
        
        
        //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    


}
