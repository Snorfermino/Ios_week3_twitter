//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Thang Nguyen on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
@objc protocol TweetDetailViewControllerDelegate{
    optional func tweetDetailViewController(detailVC: TweetDetailViewController, userInfo user:User, tweetsList tweets: Tweet)
}

class TweetDetailViewController: UIViewController {

    weak var  delegate: TweetDetailViewControllerDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    @IBOutlet weak var favLabel: UILabel!
    
    var nameText:String?
    var screenNameText:String?
    var tweetText:String?
    var timeText:String?
    var imageURL:NSURL?
    var retweetCount:String?
    var favCount:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        screenNameLabel.text = String( "@" + screenNameText!)
        tweetTextLabel.text = tweetText
        timeStampLabel.text = timeText
        avatarImage.setImageWithURL(imageURL!)
        retweetCountLabel.text = retweetCount
        favLabel.text = favCount
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedRetweet(sender: AnyObject) {
        
        
          dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func homePressed(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

