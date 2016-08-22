//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import MBProgressHUD
class HomeViewController: UIViewController {
    var requestToken:String?
    var Tweets:[Tweet]!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 120

        tableView.tableFooterView = UIView()
        
        updateTimeLine()
        //print("this is home: " + requestToken!)
        // NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(HomeViewController.onTimer), userInfo: nil, repeats: true)
            addPullToRefresh()
      
        // Do any additional setup after loading the view.
    }
    
    
    func updateTimeLine(){

        TwitterClient.sharedInstance.homeTimeLine(self.view,success: { (tweets: [Tweet]) in

            self.Tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError!) in
            print(error.localizedDescription)
        }
       
    }
    
    func addPullToRefresh(){
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl,atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
 
        
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
     

    
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (data, response, error) in
                                                                        
                                                          
                                                                        self.tableView.reloadData()
                                                        
                                                                        self.updateTimeLine()
                                                                        refreshControl.endRefreshing()	
        });
        task.resume()
    }
    

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "ViewTweetDetail" {
            if let nvc = segue.destinationViewController as? UINavigationController, detailVC = nvc.topViewController as? TweetDetailViewController {
                let ip:NSIndexPath
                ip = tableView.indexPathForSelectedRow!
                let user = Tweets![ip.row].user
               detailVC.nameText = user!.name
                detailVC.nameText = user!.name
                detailVC.screenNameText = user!.screenName
                detailVC.tweetText = Tweets![ip.row].text
                detailVC.imageURL = user!.profileImageUrl
                detailVC.timeText = Tweets![ip.row].createdAtString
                detailVC.retweetCount = String(Tweets![ip.row].retweetCount)
                detailVC.favCount = String(Tweets![ip.row].favCount)

            }
        } else {
            if let nvc = segue.destinationViewController as? UINavigationController, tweetlVC = nvc.topViewController as? DetailViewController {
                
                tweetlVC.name = User.currentUser?.name
                tweetlVC.screenName = User.currentUser?.screenName
                tweetlVC.imageUrl = User.currentUser?.profileImageUrl
            }
        }
    }
    
    
    @IBAction func pressedLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        
    }
    
    

    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if Tweets != nil {
            return Tweets!.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        let tweetUser = Tweets![indexPath.row].user
        
        cell.nameLabel.text = tweetUser!.name
        cell.screenNameLabel.text = "@"+tweetUser!.screenName!
        cell.avatarImageView.setImageWithURL((tweetUser!.profileImageUrl)!)
        cell.tweetLabel.text = Tweets![indexPath.row].text
        cell.timeLabel.text = Tweets![indexPath.row].timeSinceCreated
        return cell
    }
}

extension HomeViewController:DetailViewControllerDelegate{
    func detailViewController(homeVC: DetailViewController, option: String) {
        
            updateTimeLine()
        
        
    }
}
