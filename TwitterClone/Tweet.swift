//
//  Tweet.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/6/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import UIKit


class Tweet {
    
    var text : String
    var avatarImage : UIImage
    var id : String
    
    var favNumber : Int?
    var reTweetCount : Int?
    var userName : String
    
    
    
    init ( tweetInfo : NSDictionary ) {
        self.text = tweetInfo["text"] as String
        
        // use "let" when you can instead of var
        let userDict = tweetInfo["user"] as NSDictionary
        let url  = NSURL(string: userDict["profile_image_url"] as String)
        
        //var url = NSURL.URLWithString(userDict["profile_image_url"] as String)
        let imageData :NSData = NSData(contentsOfURL:url)
        self.avatarImage = UIImage(data:imageData)
        self.id = tweetInfo["id_str"] as String
        self.reTweetCount = tweetInfo["retweet_count"] as? Int
        self.userName = userDict["name"] as String
        
//        if let numFav = tweetInfo["favourites_count"] as? NSNumber {
//            self.favNumber = numFav
//        }
    }
    
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray //optional downcasting
        {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                    
                }
            }
            return tweets
        }
        return nil
    }
    
    class func parseJSONDataIntoSingleTweet(rawJSONData : NSData, tweet : Tweet) -> Tweet? {
        var error : NSError?
        if let tweetDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            tweet.favNumber = tweetDictionary["favorite_count"] as? Int
        }
        return tweet
    }
    
}










