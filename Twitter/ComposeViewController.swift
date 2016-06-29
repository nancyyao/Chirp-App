//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var tweetText: String?
    
    @IBOutlet weak var composeImageView: UIImageView!
    @IBOutlet weak var composeNameLabel: UILabel!
    @IBOutlet weak var composeUsernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        if let screenname = user!.screenname as? String {
            composeUsernameLabel.text = "@\(screenname)"
        }
        composeNameLabel.text = user!.name as? String
        if let imageUrl = user!.profileUrl {
            if let data = NSData(contentsOfURL: imageUrl) {
                composeImageView.image = UIImage(data: data)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        tweetText = textView.text
        TwitterClient.sharedInstance.compose(tweetText!, success: { (tweet: Tweet) in
            print("status updated")
        }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
        }
        dismissViewControllerAnimated(true, completion: nil)
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
