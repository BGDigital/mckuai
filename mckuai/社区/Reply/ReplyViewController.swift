//
//  ReplyViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/12/24.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import QuartzCore

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var bType: String!
    
    var forumId: Int!
    var operUserId: Int!
    var isNew: Int!
    var forumName: String!
    var talkId: Int!
    var talkTitle: String!
    var replyId: Int!
    var replyUserName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        if (textView.text == "") {
            textViewDidEndEditing(textView)
        }
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //评论
    @IBAction func SendReply() {
        if textView.text.isEmpty {
            UIAlertView(title: "提示", message: "你的评论还没有内容，总得写点什么", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if self.bType == "gentie" {
            //跟贴
            APIClient.sharedInstance.SendFollow(appUserIdSave, operUserId: operUserId, isNew: isNew, forumId: forumId, forumName: forumName, talkId: talkId, content: textView.text, talkTitle: talkTitle)
        } else {
            //回复
            APIClient.sharedInstance.SendReply(appUserIdSave, replyContext: textView.text, talkId: talkId, replyId: replyId, replyUserName: replyUserName)
        }

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismissKeyboard(){
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "评论..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == "评论..."){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    //供外部调用的接口
    class func loadReply(presentNavigator ctl:UINavigationController?,dict: [String: String]){
        var ReplyCtl = UIStoryboard(name: "Reply", bundle: nil).instantiateViewControllerWithIdentifier("Reply") as ReplyViewController
        
        ReplyCtl.bType = dict["type"]
        if ReplyCtl.bType! == "huifu" {
            ReplyCtl.talkId = dict["data_itemId"]?.toInt()
            ReplyCtl.replyId = dict["replyId_id"]?.toInt()
            ReplyCtl.replyUserName = dict["replyUserName"]
        } else {
            ReplyCtl.forumId = dict["forumId"]?.toInt()
            ReplyCtl.operUserId = dict["hostUserId"]?.toInt()
            ReplyCtl.isNew = dict["isNew"]?.toInt()
            ReplyCtl.forumName = dict["forumName"]
            ReplyCtl.talkId = dict["hostTalkId"]?.toInt()
            ReplyCtl.talkTitle = dict["hostTalkTitle"]
        
        }
        ctl?.pushViewController(ReplyCtl, animated: true)
        
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
