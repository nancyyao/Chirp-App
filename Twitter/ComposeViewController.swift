//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    var tweetText: String?

    @IBOutlet weak var composeImageView: UIImageView!
    @IBOutlet weak var composeNameLabel: UILabel!
    @IBOutlet weak var composeUsernameLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self

        characterCountLabel.text = String(140)
        
        let user = User.currentUser
        if let screenname = user!.screenname as? String {
            composeUsernameLabel.text = "@\(screenname)"
        }
        composeNameLabel.text = user!.name as? String
        
        composeImageView.layer.borderWidth = 0
        composeImageView.layer.cornerRadius = composeImageView.frame.height/10
        composeImageView.clipsToBounds = true

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
    
    //TEXTVIEW
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        characterCountLabel.text = String(140 - numberOfChars)
        return numberOfChars < 140;
    }
    
    //BUTTONS
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        tweetText = textView.text

        let newTweet: NSDictionary = [
            "status" : tweetText!
        ]
        
        TwitterClient.sharedInstance.compose(newTweet, success: { (tweet: Tweet) in
            print("status updated")
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
