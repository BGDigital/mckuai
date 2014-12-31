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
    //发贴类型按钮
    @IBOutlet weak var subBtn1: UIButton!
    @IBOutlet weak var subBtn2: UIButton!
    @IBOutlet weak var subBtn3: UIButton!
    @IBOutlet weak var subBtn4: UIButton!
    @IBOutlet weak var subBtn5: UIButton!
    
    var lastBtn1: UIButton!
    var lastBtn2: UIButton!
    var userId: Int!=1
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
        
        userId = appUserIdSave
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
        
        //这里会改变下面类型的文字
        switch (forumId) {
        case 1:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = false
            subBtn5.hidden = false
            subBtn1.setTitle("闲聊", forState: .Normal)
            subBtn2.setTitle("资讯攻略", forState: .Normal)
            subBtn3.setTitle("视频", forState: .Normal)
            subBtn4.setTitle("美图", forState: .Normal)
            subBtn5.setTitle("新人", forState: .Normal)
        case 2:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = false
            subBtn5.hidden = true
            subBtn1.setTitle("教程", forState: .Normal)
            subBtn2.setTitle("技巧", forState: .Normal)
            subBtn3.setTitle("红石研究", forState: .Normal)
            subBtn4.setTitle("讨论", forState: .Normal)
        case 3:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = true
            subBtn4.hidden = true
            subBtn5.hidden = true
            subBtn1.setTitle("社区活动", forState: .Normal)
            subBtn2.setTitle("服务器活动", forState: .Normal)
        case 4:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = true
            subBtn5.hidden = true
            subBtn1.setTitle("地图", forState: .Normal)
            subBtn2.setTitle("皮肤", forState: .Normal)
            subBtn3.setTitle("其它", forState: .Normal)
        case 5:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = false
            subBtn5.hidden = false
            subBtn1.setTitle("单人游戏", forState: .Normal)
            subBtn2.setTitle("多人游戏", forState: .Normal)
            subBtn3.setTitle("MOD", forState: .Normal)
            subBtn4.setTitle("材质包", forState: .Normal)
            subBtn5.setTitle("麦块反馈", forState: .Normal)
        case 6:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = false
            subBtn5.hidden = false
            subBtn1.setTitle("求助", forState: .Normal)
            subBtn2.setTitle("教程", forState: .Normal)
            subBtn3.setTitle("资讯", forState: .Normal)
            subBtn4.setTitle("攻略", forState: .Normal)
            subBtn5.setTitle("插件", forState: .Normal)
        case 7:
            subBtn1.hidden = false
            subBtn2.hidden = false
            subBtn3.hidden = false
            subBtn4.hidden = false
            subBtn5.hidden = false
            subBtn1.setTitle("其它", forState: .Normal)
            subBtn2.setTitle("生存", forState: .Normal)
            subBtn3.setTitle("娱乐", forState: .Normal)
            subBtn4.setTitle("竞技", forState: .Normal)
            subBtn5.setTitle("创造", forState: .Normal)
        default:
            break;
        }

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
        

            var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
            indicator.text = "正在发送数据..."
            
            dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
                APIClient.sharedInstance.SendPost(self.userId, forumId: self.forumId, forumName: self.forumName, talkTypeId: self.talkTypeId, talkTypeName: self.talkTypeName, talkTitle: self.caption.text, content: self.text.text)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    WIndicator.removeIndicatorFrom(self.view, animation: true)
                })
                
            })

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
