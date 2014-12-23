//
//  RootViewController.swift
//  smartmixer
//
//  Created by kingzhang on 8/24/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

//var rootController:RootViewController!

let appID:String = "3Z8C4UK6GU"
var appUserIdSave=NSUserDefaults.standardUserDefaults().objectForKey("userId") as Int!

class RootViewController: UITabBarController{
    
    //let launchImgUrl = "http://pic2.zhimg.com/cf3bcf3ca5c7a503e7b58d0f498f14bc.jpg"
    var loginView:UIViewController!
    var welcome:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(appUserIdSave == nil){
            loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
            self.view.addSubview(loginView.view)
            
        }else {
            println(appUserIdSave)
        }
        appUserIdSave=2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertView(alertView: UIAlertView,clickedButtonAtIndex buttonIndex: Int) {
        if( buttonIndex==0 ) {
            loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
            self.view.addSubview(loginView.view)
        }
    }

    
}
