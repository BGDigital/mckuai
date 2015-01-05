//
//  TieziController.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/16.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class TieziController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var hello: UIView!
    
    @IBOutlet weak var comment_border: UIView!
    
    @IBOutlet weak var loading: UIView!
    
    var tid:String?
    
    var loginId:String!{
        get{
            if let uid = appUserIdSave{
                return String(uid)
            }else{
                McLogin.showLoginView(self.navigationController!)
//                var loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
//                self.navigationController!.pushViewController(loginView,animated:true)
                return nil
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        println(tid)
        if let id = tid {
//            println("here")
            var url = NSURL(string: APIRootURL + "talk.do?act=one&id="+id)
//            url = NSURL(string: "http://192.168.10.104/")
            var req = NSURLRequest(URL: url!)
            println(req)
            webview.loadRequest(req)
        }
        webview.delegate = self
        
        
        comment_border.layer.borderWidth = 1;
        var bdc = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
        comment_border.layer.borderColor = bdc.CGColor

    }
    

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool{
        let url = request.URL
        if (url.scheme == "ios") {
            var fun = url.host
            var arg0 = url.query
            
            
            let param = GTUtil.getQueryDictionary(arg0!)
            
            dispatchAction(fun!,param: param);
            
            return false;
        }
        
        return true;
    }
    func webViewDidStartLoad(webView: UIWebView) {
        loading.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loading.hidden = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        var label = loading.subviews[0] as UILabel;
        label.text = "加载出错"
    }
    
    
    class func loadTiezi(presentNavigator ctl:UINavigationController?,id:String){
        var tiezi = UIStoryboard(name: "tiezi", bundle: nil).instantiateViewControllerWithIdentifier("Tiezi") as TieziController
        
        tiezi.tid = id
        if (ctl != nil) {
            ctl?.pushViewController(tiezi, animated: true)
        } else {
            ctl?.presentViewController(tiezi, animated: true, completion: nil)
        }
        
    }
    
    private func dispatchAction(action:String,param:[String:String]) {
        if action == "getuid" {
            var uid = self.loginId
            
        }
        if action == "viewuser" && param["id"] != nil{
            if let id = param["id"]!.toInt(){
                OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: id)
            }
        }
        var param1 = param;
        if action == "reply" {
            println("Reply...........")
            if let uid = self.loginId{
                param1["type"] = "huifu"
                ReplyViewController.loadReply(presentNavigator: self.navigationController, dict: param1)
            }
        }
    }
    @IBAction func rePost(){
        println("跟帖")
        if let uid = self.loginId{
            if let query = webview.stringByEvaluatingJavaScriptFromString("getParameters()"){
//                println("返回内容："+query)
                var param = GTUtil.getQueryDictionary(query)
                param["type"] = "gentie"
                println(param)
                ReplyViewController.loadReply(presentNavigator: self.navigationController, dict: param)
            }else{
                println("没有内容")
            }
        }else{
            println("未登录用户")
        }
    }
    
    func afterReply(){
        println("afterReply().........")
        webview.stringByEvaluatingJavaScriptFromString("addReplyHtml()");
    }
}