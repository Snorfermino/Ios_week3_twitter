//
//  DetailViewController.swift
//  TwitterDemo
//
//  Created by Thang Nguyen on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
@objc protocol DetailViewControllerDelegate{
    optional func detailViewController(homeVC: DetailViewController, option: String)
}
class DetailViewController: UIViewController {

    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    
    @IBOutlet weak var textfield: UITextView!
   

    @IBOutlet weak var wordCountLabel: UILabel!
    var delegate: DetailViewControllerDelegate?
    var name:String?
    var screenName:String?
    var imageUrl:NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        screennameLabel.text = "@" + screenName!
        userAvatarImage.setImageWithURL(imageUrl!)
        
        textfield.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func postTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.createTweet(textfield.text)
        delegate?.detailViewController!(self, option: "created")
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    

    
}

extension DetailViewController:UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    func textViewDidChange(textView: UITextView) {
        let wordTyped = textView.text!.characters.count
        if wordTyped == 140 {
            textView.editable = false
        }
        wordCountLabel.text = String( 140 - wordTyped)
        
    }
}

