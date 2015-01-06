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
//var appUserIdSave=NSUserDefaults.standardUserDefaults().objectForKey("userId") as Int!
var appUserIdSave: Int!
var loginView:McLogin!
var loginViewOld:Login!
var selectItemTag = 0
var _lastSelectedIndex = 0

var selectedIndex = 0
class RootViewController: UITabBarController, UITabBarControllerDelegate{
    
    //let launchImgUrl = "http://pic2.zhimg.com/cf3bcf3ca5c7a503e7b58d0f498f14bc.jpg"

    var welcome:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        //修改tabbar的选中颜色
        tabBar.selectedImageTintColor = UIColor(red: 0.224, green: 0.749, blue: 0.361, alpha: 1.00)
        //读取用户登录信息
        var userDefault = NSUserDefaults.standardUserDefaults()
        appUserIdSave = userDefault.integerForKey("appUserIdSave")
        println("appUserIdSave:\(appUserIdSave)")
        //判断是否登录
        if(appUserIdSave == nil || appUserIdSave == 0){
//            loginViewOld=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as Login
//            self.view.addSubview(loginViewOld.view)

           McLogin.showLoginView(self)
        }
        //测试ID，一叶之秋
        appUserIdSave=2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        selectItemTag = item.tag
        if(item.tag == 3 && appUserIdSave == nil){
            McLogin.showLoginView(self)
        }
     }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //返回false不变，返回true要变
        return !(selectItemTag == 3 && appUserIdSave == nil)
        //return true
    }
}
