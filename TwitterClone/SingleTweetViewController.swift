//
//  SingleTweetViewController.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/8/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import Accounts
import Social


class SingleTweetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var tweet : Tweet!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    
    
    var networkController : NetworkController!
    
    
    @IBOutlet weak var singleTweetTextView: UITextView!
    
    @IBOutlet weak var singleTweetProfileImageView: UIImageView!
    
    @IBOutlet weak var singleTweetUserNameLabelView: UILabel!
    
    @IBOutlet weak var singleTweetRetweetNumberView: UILabel!
    
    @IBOutlet weak var singleTweetFavoriteCountView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        if self.tweet.favNumber == nil {
            self.networkController.fetchSingleTweet(tweet, completionHandler: {
                (errorDescription, singleTweet) -> (Void) in
                if errorDescription != nil {
                    //alert user something is wrong
                } else {
                    self.tweet = singleTweet
                    self.singleTweetFavoriteCountView.text = self.tweet.favNumber?.description
                }
            })
        } else {
            self.singleTweetFavoriteCountView.text = tweet.favNumber?.description
        }
            
        self.singleTweetTextView.text = self.tweet.text
        self.singleTweetProfileImageView?.image = self.tweet.avatarImage
        self.singleTweetUserNameLabelView.text = self.tweet.userName
        self.singleTweetRetweetNumberView.text = self.tweet.reTweetCount?.description
        
        // when click on the target, add gesture recognizer
        let pressGesture = UITapGestureRecognizer(target: self, action: "toUserView:")
        pressGesture.delegate = self
        self.singleTweetProfileImageView.addGestureRecognizer(pressGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UIGesture
    
    func toUserView(gesture : UITapGestureRecognizer) {
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SINGLEUSER") as SingleUserViewController
        destinationVC.tweet = self.tweet
        self.navigationController?.pushViewController(destinationVC, animated: true)

    }
    


    
    
    
    
    
    

}
