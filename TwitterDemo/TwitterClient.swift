//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Thang Nguyen on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import MBProgressHUD
class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance =  TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "3Yq6PW6LSBSGMkXk5LHPNKTNL", consumerSecret: "3sR73lU0GHnqZEZzQ9YmLPNFj04x5wM7jN7jjPKWdMTyaIxOGx")
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeLine(view: UIView, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            MBProgressHUD.hideHUDForView(view, animated: true)
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")

        })

    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)

            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
                failure(error)
        })
    }
    
    func createTweet(tweetText:String){
        let url = "1.1/statuses/update.json"
        let parameter = ["status" : tweetText]


        POST(url, parameters: parameter, success: nil) { (session: NSURLSessionDataTask?, error: NSError!) in
            print(error.localizedDescription)
        }
    }
    
    func login(success: ()->(), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        // To make sure whoever login before, logout first
        deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "bluebird123://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            //self.requestToken = requestToken.token
            print("I got request token = \(requestToken.token)")
            
            // TODO: redirect to authrization url
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
            
            
        }) { (error: NSError!) in
            
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout(){
        User._currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("I got access token = \(accessToken.token)")
            //self.requestToken = accessToken.token
            self.currentAccount({ (user: User) in
                
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
            
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
}
