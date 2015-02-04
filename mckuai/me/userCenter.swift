//
//  userCenterViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class UserCenter: UIViewController, UIAlertViewDelegate {
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let ITEM_WIDTH:CGFloat = 45
    let ITEM_HEIGHT:CGFloat = 45
    
    
    @IBOutlet weak var headBg: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var fuzhu: UILabel!
    
    @IBOutlet weak var mingren: UILabel!
    
    @IBOutlet weak var dynamic_btn: UIButton!
    
    @IBOutlet weak var message_btn: UIButton!
    
    @IBOutlet weak var container_v: UIView!
    
    @IBOutlet weak var exitLogin_btn: UIButton!
    @IBOutlet weak var denglu_btn: UIButton!
    @IBOutlet weak var no_dynamic_icon: UIImageView!
    
    @IBOutlet weak var no_dynamic_lable: UILabel!
    var imageCache = Dictionary<String, UIImage>()
    
    var json = JSON("")
    var http_url = UserCenterUrl;
    
    var dynamicTableView:Dynamic!=nil
    var messageTableView:Message!=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoginout = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        //隐藏navigationbar
//        setRightBarButtonItem();
        self.navigationController?.navigationBar.hidden = true
        
        if(appUserIdSave != nil && appUserIdSave != 0){
            showHiddenLable();
            self.denglu_btn.hidden = true;
            self.no_dynamic_icon.hidden = true;
            self.no_dynamic_lable.hidden = true;
            /*
            //navigation bar 背景
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.clipsToBounds = true;
            self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
            self.navigationController?.navigationBar.translucent=true
            setRightBarButtonItem()
            */
//            initData()
            if !initData() {
                changeStatusClicked(self.dynamic_btn)
            }
            //changeStatusClicked(self.dynamic_btn)
        }else{
            hiddenLable();
            self.denglu_btn.hidden = false;
            self.no_dynamic_icon.hidden = false;
            self.no_dynamic_lable.hidden = false;
            setLoginButtonStyle();
            
        }


    }
    

    
    func setLoginButtonStyle() {
         self.denglu_btn.layer.masksToBounds = true;
         self.denglu_btn.layer.borderWidth = 1;
         self.denglu_btn.layer.borderColor = UIColor(red: 0.353, green: 0.796, blue: 0.478, alpha: 1.00).CGColor;
         self.denglu_btn!.userInteractionEnabled = true
         self.denglu_btn.addTarget(self, action:"dengluButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // 用户登录
    func dengluButtonClick(sender:UIButton) {
        println("登录注册按钮");
        self.navigationItem.rightBarButtonItem?.title = "注册"
        UserLogin.showUserLoginView(presentNavigator: self.navigationController)
    }
    
    func hiddenLable() {
        self.headBg.hidden = true;
        self.headImage.hidden = true;
        self.fuzhu.hidden = true;
        self.userName.hidden = true;
        self.level.hidden = true;
        self.mingren.hidden = true;
        self.dynamic_btn.enabled = false;
        self.message_btn.enabled = false;
        self.exitLogin_btn.enabled = false;
        self.dynamic_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
        self.message_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
    }
    
    func showHiddenLable() {
        self.headBg.hidden = false;
        self.headImage.hidden = false;
        self.fuzhu.hidden = false;
        self.userName.hidden = false;
        self.level.hidden = false;
        self.mingren.hidden = false;
        self.dynamic_btn.enabled = true;
        self.message_btn.enabled = true;
        self.exitLogin_btn.enabled = true;
    }
    
    @IBAction func userLogout() {
        Profile.loadProfile(self.navigationController!)
        //UIAlertView(title: "提示", message: "你确定要注销吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        
        if(isLoginout == true) {
            if(self.dynamicTableView != nil){
                self.dynamicTableView.view = nil
                self.dynamicTableView = nil
                
            }
            if(self.messageTableView != nil){
                self.messageTableView.view = nil
                self.messageTableView = nil
            }
            
            viewDidLoad()
        }
        

        
    }
    
    func initData() -> Bool   {
        var flag:Bool = false
        flag = GTUtil.CheckNetBreak()
        if(!flag){
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "正在获取"
            
            var paramDictionary :Dictionary<String,String> = ["act":"one","id":"\(appUserIdSave)"]
            
                    Alamofire.request(.GET,http_url, parameters: paramDictionary)
                        .responseJSON { (request, response, data, error) in
            
                            if data == nil {
                                println("取不到数据，不显示")
                                //self.tableView.hidden = true
                                self.showNoLogin()
                                flag = true
                                hud.hide(true)
                            } else {
                                var jsonParse = data as NSDictionary
                                self.json = JSON(jsonParse)
                                var count = self.json["dataObject","user"].count
                                if(count == 0) {
                                    self.showNoLogin()
                                    flag = true
                                }
                                hud.hide(true)
                            }
            
                    }

        }
        return flag


    }
    
    func showNoLogin(){
        //var loginAlertView = UIAlertView(title: "提示", message: "获取数据失败", delegate: self, cancelButtonTitle: "确定")
        //loginAlertView.show()
        GTUtil.showCustomHUD(view, title: "获取数据出错", imgName: "HUD_ERROR")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRightBarButtonItem() {
        self.rightButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.rightButton!.frame=CGRectMake(0,0,ITEM_WIDTH,ITEM_HEIGHT)
        self.rightButton!.tintColor = UIColor.whiteColor()
        self.rightButton!.setTitle("注册", forState: UIControlState.Normal)
        self.rightButton!.tag=10
        self.rightButton!.userInteractionEnabled = true
        self.rightButton?.addTarget(self, action: "rightBarButtonItemClicked", forControlEvents: UIControlEvents.TouchUpInside)
//        self.rightButton!.setImage(UIImage(named: "searchCenter_d"),forState:UIControlState.Normal)
//        self.rightButton!.setImage(UIImage(named: "searchCenter"),forState:UIControlState.Highlighted)
        //self.rightButton!.imageEdgeInsets = UIEdgeInsetsMake(0,30, 10, 0);
        var barButtonItem = UIBarButtonItem(customView:self.rightButton!)
        
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target:nil,action:nil)
        negativeSpacer.width = -17
        self.navigationItem.rightBarButtonItems = [negativeSpacer,barButtonItem];
        
    }
    


    func rightBarButtonItemClicked() {
        if(self.rightButton!.tag == 10) {
            var alertView = UIAlertView(title: "消息提示框", message: "搜索按钮被电击了", delegate: self, cancelButtonTitle: "取消")
            alertView.show()
        }
        
    }
    


    @IBAction func changeStatusClicked(sender: UIButton) {
        var btn_tag=sender.tag
        if(btn_tag == 20){
            println("加载动态消息")
            self.dynamic_btn.setTitleColor(UIColor(red: 0.098, green: 0.690, blue: 0.243, alpha: 1.00),forState:UIControlState.Normal)
            self.message_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
            if(dynamicTableView == nil){
                dynamicTableView = UIStoryboard(name: "Dynamic", bundle: nil).instantiateViewControllerWithIdentifier("dynamicSb")as Dynamic
                dynamicTableView.view.frame = CGRect(x: 0, y: 0, width: container_v.frame.width, height: container_v.frame.height)
                dynamicTableView.NavigationController = self.navigationController
                dynamicTableView.userInfo = self
                container_v.addSubview(dynamicTableView.view)
            }else{
                println("缓存view")
            }
            container_v.bringSubviewToFront(dynamicTableView.view)
        }else if(btn_tag == 30){
             
//            OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: 2)
            
            println("加载个人消息")
            self.message_btn.setTitleColor(UIColor(red: 0.098, green: 0.690, blue: 0.243, alpha: 1.00),forState:UIControlState.Normal)
            self.dynamic_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
            
            if(messageTableView == nil){
                messageTableView = UIStoryboard(name: "Message", bundle: nil).instantiateViewControllerWithIdentifier("messageSb")as Message
                messageTableView.view.frame = CGRect(x: 0, y: 0, width: container_v.frame.width, height: container_v.frame.height)
                messageTableView.NavigationController = self.navigationController
                messageTableView.userInfo = self
                container_v.addSubview(messageTableView.view)
            } else {
                //messageTableView.reloadData()
                println("缓存view")
            }
            container_v.bringSubviewToFront(messageTableView.view)
    }
    }

    func setUserInfo(){
        
        var url = self.json["dataObject","user","headImg"].string!
        
        GTUtil.loadImageView(img: self.headImage, url: url)
        self.headImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.userName.text = self.json["dataObject","user","nike"].string
        self.level.text = "LV."+String(self.json["dataObject","user","level"].int!)
        var isServerActor = self.json["dataObject","user","isServerActor"].int
        if(isServerActor == 1){
            self.fuzhu.text = "腐"
            self.mingren.hidden = true
        } else if(isServerActor == 2){
            self.fuzhu.text = "名"
            self.mingren.hidden = true
        } else {
            self.mingren.hidden = true
            self.fuzhu.hidden = true
        }
    }




}
