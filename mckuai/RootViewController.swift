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

class RootViewController: UITabBarController , ChangeTableDelegate{
    
    let launchImgUrl = "http://news-at.zhihu.com/api/3/start-image/640*960"
    var welcome:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        initControllerView()
        customTabBar()
        rootController = self
        /**/
        if(!NSUserDefaults.standardUserDefaults().boolForKey("Launched")) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Launched")
            
            welcome = UIStoryboard(name:"Launch",bundle:nil).instantiateViewControllerWithIdentifier("welcome") as UIViewController
            self.view.addSubview(welcome.view)
        }
        /**/
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
    
    var tabBarView:TabBarViewController!
    //加载工具栏
    func customTabBar()
    {
        self.tabBar.hidden = true;
        var array = NSBundle.mainBundle().loadNibNamed("TabBarView", owner: self, options: nil)
            as  [TabBarViewController]!
        tabBarView = array[0]
        tabBarView.changeTableDelegate = self
        tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 69 , width: self.view.frame.size.width, height: 70)
        self.view.addSubview(tabBarView)
        tabBarView.initSelected()
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
    }
    
}
