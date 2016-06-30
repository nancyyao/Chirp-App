//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/30/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    var replyText: String?
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var replyNameLabel: UILabel!
    @IBOutlet weak var replyUsernameLabel: UILabel!
    @IBOutlet weak var replyCharacterCount: UILabel!
    @IBOutlet weak var textView: UITextView!
    var replyId: Int!
    var screenname: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        replyCharacterCount.text = String(140)
        
        textView.text = "@" + screenname + " "
        
        let user = User.currentUser
        if let screenname = user!.screenname as? String {
            replyUsernameLabel.text = "@\(screenname)"
        }
        replyNameLabel.text = user!.name as? String
        if let imageUrl = user!.profileUrl {
            if let data = NSData(contentsOfURL: imageUrl) {
                replyImageView.image = UIImage(data: data)
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
        replyCharacterCount.text = String(140 - numberOfChars)
        return numberOfChars < 140;
    }
    
    //BUTTONS
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onReplyButton(sender: UIBarButtonItem) {
        replyText = textView.text
        
        let newTweet: NSDictionary = [
            "status" : replyText!,
            "in_reply_to_status_id" : replyId
        ]
        
        TwitterClient.sharedInstance.compose(newTweet, success: { (tweet: Tweet) in
            print("replied successfully")
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        dismissViewControllerAnimated(true, completion: nil)
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


