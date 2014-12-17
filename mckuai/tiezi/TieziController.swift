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
    
    var tid:String?
    var loginId:String!{
        get{
            if let uid = appUserIdSave{
                return String(uid)
            }else{
                var loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
                self.navigationController!.pushViewController(loginView,animated:true)
                return nil
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(tid)
        if let id = tid {
            
            println("here")
            var url = NSURL(string: "http://221.237.152.39:8081/talk.do?act=one&id="+id)
            var req = NSURLRequest(URL: url!)
            webview.loadRequest(req)
        }
        webview.delegate = self

    }
    

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool{
        let url = request.URL
        if (url.scheme == "ios") {
            var fun = url.host
            var arg0 = url.query
            
            if fun! == "getuid" {
                var uid = self.loginId
            }
            return false;
        }
        return true;
    }
    
    class func loadTiezi(presentNavigator ctl:UINavigationController,id:String){
        var tiezi = UIStoryboard(name: "tiezi", bundle: nil).instantiateViewControllerWithIdentifier("Tiezi") as TieziController
        
        tiezi.tid = id
        
        ctl.pushViewController(tiezi, animated: true)
        
    }
    
    
}