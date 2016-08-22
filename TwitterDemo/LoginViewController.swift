//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager
import MBProgressHUD

class LoginViewController: UIViewController {
    
    var requestToken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        print("login")
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let client = TwitterClient.sharedInstance
        
        client.login({ 
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError!) in
                print("Error: \(error.localizedDescription)")
        }
        

    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
