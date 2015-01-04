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

let tencentAppKey = "101155101"
var appUserIdSave=NSUserDefaults.standardUserDefaults().objectForKey("userId") as Int!
var loginView:McLogin!
var loginViewOld:Login!
var _lastSelectedIndex = 0

var selectedIndex = 0
class RootViewController: UITabBarController{
    
    //let launchImgUrl = "http://pic2.zhimg.com/cf3bcf3ca5c7a503e7b58d0f498f14bc.jpg"

    var welcome:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //修改tabbar的选中颜色
        tabBar.selectedImageTintColor = UIColor(red: 0.224, green: 0.749, blue: 0.361, alpha: 1.00)
        //判断是否登录
        if(appUserIdSave == nil){
            loginViewOld=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as Login
            self.view.addSubview(loginViewOld.view)

//           McLogin.showLoginView(self)
        }else {
            println(appUserIdSave)
        }
        //测试ID，一叶之秋
        appUserIdSave=6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    func alertView(alertView: UIAlertView,clickedButtonAtIndex buttonIndex: Int) {
//        if( buttonIndex==0 ) {
//            loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
//            self.view.addSubview(loginView.view
//        }
//    }
    
     override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.tag == 3 && appUserIdSave == nil){
//            McLogin.showLoginView(self)
//              self.view.window?.rootViewController?.presentViewController(moreViewController, animated: false, completion: nil)
        }
        
        

     }


//    override func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        println("shouldSelectViewController")
//    }
//    
}
