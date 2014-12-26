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
        /*
        //发贴
        APIClient.sharedInstance.SendPost(1, forumId: forumId, forumName: forumName, talkTypeId: talkTypeId, talkTypeName: talkTypeName, talkTitle: caption.text, content: text.text)
        */
        
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
    class func loadReply(presentNavigator ctl:UINavigationController?,id:String){
        var ReplyCtl = UIStoryboard(name: "Reply", bundle: nil).instantiateViewControllerWithIdentifier("Reply") as ReplyViewController
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
