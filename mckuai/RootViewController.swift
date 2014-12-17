//
//  RootViewController.swift
//  smartmixer
//
//  Created by kingzhang on 8/24/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

var rootController:RootViewController!

let appID:String = "3Z8C4UK6GU"
var appUserIdSave=NSUserDefaults.standardUserDefaults().objectForKey("userId") as Int!

class RootViewController: UITabBarController , ChangeTableDelegate{
    
    let launchImgUrl = "http://pic2.zhimg.com/cf3bcf3ca5c7a503e7b58d0f498f14bc.jpg"
    var loginView:UIViewController!
    var welcome:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //appUserIdSave=2
        initControllerView()
        customTabBar()
        rootController = self
        /*
        if(!NSUserDefaults.standardUserDefaults().boolForKey("Launched")) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Launched")
        
        welcome = UIStoryboard(name:"Launch",bundle:nil).instantiateViewControllerWithIdentifier("welcome") as UIViewController
        self.view.addSubview(welcome.view)
        }
        */
        
        if(appUserIdSave == nil){
            loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
            self.view.addSubview(loginView.view)
            
        }else {
            println(appUserIdSave)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //加载界面
    func initControllerView()
    {
        var home = UIStoryboard(name: "home", bundle: nil).instantiateInitialViewController() as UIViewController
        
        var community = UIStoryboard(name:"Community", bundle:nil).instantiateInitialViewController() as UIViewController
        var chat = UIStoryboard(name: "chat", bundle: nil).instantiateInitialViewController() as UIViewController
        var me = UIStoryboard(name:"userCenter",bundle:nil).instantiateInitialViewController() as UIViewController
        var tabBarViewControllers = [home, community, chat, me]
        self.setViewControllers(tabBarViewControllers, animated: true)
        
    }
    
    var tabBarView = CustomTabBar()
    // 自定义TabBar
    func customTabBar(){
        
        self.tabBar.hidden = true;
        var array = NSBundle.mainBundle().loadNibNamed("CustomTabBarView", owner: self, options: nil)
        tabBarView = array[0] as CustomTabBar
        tabBarView.changeTableDelegate = self
        tabBarView.dynamicButton.selected = true
        tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 49 , width: 320, height: 49)
        self.view.addSubview(tabBarView)
    }
    
    //显示或影藏
    func showOrhideToolbar(opt:Bool){
        if(opt){
            UIView.animateWithDuration(0.3, animations: {
                self.tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 69 , width: self.view.frame.size.width, height: 70)
            })
        }else{
            UIView.animateWithDuration(0.3, animations: {
                self.tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 70)
            })
        }
        
    }
    
    func changeIndex(index: Int) {
        
        switch(index)
        {
        case 0: println("0")
        case 4: println("4")
        default: println("default")
            
        }
        self.selectedIndex = index

        if(index == 3 && appUserIdSave == nil){
            var alertView = UIAlertView(title: "QQ帐号一键登录", message: "", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
        }else {
            self.selectedIndex = index
        }

        
    }
    
    func alertView(alertView: UIAlertView,clickedButtonAtIndex buttonIndex: Int) {
        if( buttonIndex==0 ) {
            loginView=UIStoryboard(name:"Login",bundle:nil).instantiateViewControllerWithIdentifier("login") as UIViewController
            self.view.addSubview(loginView.view)
        }
    }

    
}
