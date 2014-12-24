//
//  PostViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/12/16.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import QuartzCore

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var text: UITextView!
    
    var lastBtn1: UIButton!
    var lastBtn2: UIButton!
    var forumId: Int!=0
    var forumName: String!
    var talkTypeId: Int!=0
    var talkTypeName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.delegate = self
        if (text.text == "") {
            textViewDidEndEditing(text)
        }
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        //textView 边框
        //UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1.00).CGColor
        //text.layer.borderColor = UIColor.redColor().CGColor
        //text.layer.borderWidth = 1.0
        //text.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        text.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "内容"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == "内容"){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    //设置版块的选中状态
    @IBAction func setBankuaiSelect(sender : UIButton) {
        forumId = sender.tag
        forumName = sender.titleLabel?.text
        sender.setBackgroundImage(UIImage(named: "post_big_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        sender.selected = true
        if lastBtn1 != nil {
            lastBtn1.selected = false
        }
        lastBtn1 = sender
        
        println("板块按钮tag:\(sender.tag)")
    }
    //设置类型的选中状态
    @IBAction func setTypeSelected(sender: UIButton) {
        talkTypeId = sender.tag
        talkTypeName = sender.titleLabel?.text
        sender.setBackgroundImage(UIImage(named: "post_small_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        sender.selected = true
        if lastBtn2 != nil {
            lastBtn2.selected = false
        }
        lastBtn2 = sender
        
        println("类型按钮tag:\(sender.tag)")
    }
    
    //发贴
    @IBAction func SendPost() {
        println("发帖")
        if forumId == 0 {
            UIAlertView(title: "提示", message: "你没有选择版块，请先选择再发贴", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if talkTypeId == 0 {
            UIAlertView(title: "提示", message: "你没有选择贴子类型，请选择后再发贴", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if caption.text.isEmpty {
            UIAlertView(title: "提示", message: "你的贴子还没有标题，写一个吧", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if text.text.isEmpty {
            UIAlertView(title: "提示", message: "你的贴子还没有内容，总得写点什么", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        //发贴
        APIClient.sharedInstance.SendPost(1, forumId: forumId, forumName: forumName, talkTypeId: talkTypeId, talkTypeName: talkTypeName, talkTitle: caption.text, content: text.text)
        
        self.navigationController?.popViewControllerAnimated(true)
        println("发贴成功,怎么返回呢？")
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
