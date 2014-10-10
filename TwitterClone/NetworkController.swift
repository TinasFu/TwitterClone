//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/8/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import Accounts
import Social


class NetworkController {
    
    //        class var sharedInstance: NetworkController {
    //        struct Static {
    //            static var instance: NetworkController?
    //            static var token: dispatch_once_t = 0
    //            }
    //            dispatch_once(&Static.token) {
    //                Static.instance = NetworkController()
    //            }
    //            return Static.instance!
    //        }
    
    
    
    
    
    var twitterAccount : ACAccount?
    let imageQueue = NSOperationQueue()
    
    
    init() {
        self.imageQueue.maxConcurrentOperationCount = 6
        
    }
    
    
    
    //********************* fetch home timeline tweets *********************
    
    func fetchHomeTimeLine(completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // requestAccess process takes some time
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                //setup our twitter rquest
                
                
                
                let url = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL : url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                //httpREsponse has the status code we are looking for
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(tweets?.count)//right here we are on a background queue aka thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        //self.tableView.reloadData() //we are not on the main thread?
                    case 400...499:
                        println("This is the clients fault.")
                        completionHandler(errorDescription: "This is your fault", tweets: nil)
                    case 500...599:
                        println("This is the servers fault.")
                        completionHandler(errorDescription: "Our servers are currently down", tweets: nil)
                    default:
                        println("something bad happened")
                    }
                })
                
            }
        }
    }
    
    
    //************** fetch single tweet information ***************************************
    
    func fetchSingleTweet(tweet: Tweet, completionHandler : (errorDescription : String?, singleTweet : Tweet) -> (Void)) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // requestAccess process takes some time
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                //setup our twitter request
                let url = NSURL(string:"https://api.twitter.com/1.1/statuses/show.json?id=\(tweet.id)")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL : url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                //httpREsponse has the status code we are looking for
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        let singleTweet = Tweet.parseJSONDataIntoSingleTweet(data, tweet : tweet)
                        //right here we are on a background queue aka thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, singleTweet: singleTweet!)
                        })
                        
                        //self.tableView.reloadData() //we are not on the main thread?
                    case 400...499:
                        println("This is the clients fault.")
                        //completionHandler(errorDescription: "This is your fault", singleTweet: nil)
                    case 500...599:
                        println("This is the servers fault.")
                        //completionHandler(errorDescription: "Our servers are currently down", singleTweet: nil)
                    default:
                        println("something bad happened")
                    }
                })
                
            }
        }
    }
    
    // ********************* fetch a specific user's time line tweets ***********************
    
    func fetchUserTimeLine(tweet: Tweet, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // requestAccess process takes some time
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                //setup our twitter request
                
                
                
                let url = NSURL(string:"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(tweet.screenName)")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL : url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                //httpREsponse has the status code we are looking for
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(tweets?.count)//right here we are on a background queue aka thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        
                        //self.tableView.reloadData() //we are not on the main thread?
                    case 400...499:
                        println("This is the clients fault.")
                        completionHandler(errorDescription: "This is your fault", tweets: nil)
                    case 500...599:
                        println("This is the servers fault.")
                        completionHandler(errorDescription: "Our servers are currently down", tweets: nil)
                    default:
                        println("something bad happened")
                    }
                })
                
            }
        }
        
    }
    
    func downloadUserImageForTweet(tweet : Tweet, completionHandler : (image : UIImage) -> (Void)){
        //make sure to use imageQueue so we are not using the main thread
        self.imageQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: tweet.imageURL)
            let imageData = NSData(contentsOfURL: url)// network call
            let avatarImage = UIImage(data: imageData)
            tweet.avatarImage = avatarImage
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: avatarImage)
            })
            
        }
        
    }
    
}

