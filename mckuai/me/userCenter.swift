//
//  userCenterViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire


class UserCenter: UIViewController {
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let ITEM_WIDTH:CGFloat = 45
    let ITEM_HEIGHT:CGFloat = 45
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var fuzhu: UILabel!
    
    @IBOutlet weak var mingren: UILabel!
    
    @IBOutlet weak var dynamic_btn: UIButton!
    
    @IBOutlet weak var message_btn: UIButton!
    
    @IBOutlet weak var container_v: UIView!
    
    var imageCache = Dictionary<String, UIImage>()
    
    var json = JSON("")
    var http_url = UserCenterUrl;
    override func viewDidLoad() {
        super.viewDidLoad()
        if(appUserIdSave != nil){
            
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
            //隐藏navigationbar
            self.navigationController?.navigationBar.hidden = true
            /*
            //navigation bar 背景
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.clipsToBounds = true;
            self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
            self.navigationController?.navigationBar.translucent=true
            setRightBarButtonItem()
            */
            initData()
            changeStatusClicked(self.dynamic_btn)
        }else{
            

        }


    }
    

    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    func initData() {
        var paramDictionary :Dictionary<String,String> = ["act":"one","id":"\(appUserIdSave)"]
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    println("取不到数据，不显示")
                    //self.tableView.hidden = true
                    self.showNoLogin()
                    
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    var count = self.json["dataObject","user"].count
                    println("count\(count)")
                    println(self.json["state"])
                    if(count == 0) {
                        self.showNoLogin()
                    } else {
                        var url = self.json["dataObject","user","headImg"].string!
                        
                        GTUtil.loadImageView(img: self.headImage, url: url)
                        self.headImage.contentMode = UIViewContentMode.ScaleAspectFit
//                        let image = self.imageCache[url]
//                        if (image == nil) {
//                            
//                            //println("缓存中没有图片，从网上获取")
//                            let imgURL: NSURL = NSURL(string:url)!
//                            let request:NSURLRequest = NSURLRequest(URL: imgURL)
//                            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
//                                var img=UIImage(data:data)
//                                self.headImage.image=img
//                                self.headImage.contentMode = UIViewContentMode.ScaleAspectFit
//                                self.imageCache[url] = img })
//                            
//                        }
//                        else
//                        {
//                            //println("缓存中有图片，直接显示出来")
//                            self.headImage.image=image
//                        }
                        
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
        }

    }
    
    func showNoLogin(){
        var loginAlertView = UIAlertView(title: "登陆提示框", message: nil, delegate: self, cancelButtonTitle: "取消")
        loginAlertView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setRightBarButtonItem() {
        //self.rightButtonItem=UIBarButtonItem(image:UIImage(named: "searchCenter_d"),style: UIBarButtonItemStyle.Plain, target: self,action: "rightBarButtonItemClicked")
        //self.rightButtonItem.frame=CGRectMake(0,0,32,32)
        //self.rightButtonItem.setBackgroundImage(UIImage(named: "searchCenter_d"),forState:UIControlState.Normal)
        //self.navigationItem.rightBarButtonItem = self.rightButtonItem
        //self.navigationItem.rightBarButtonItem.frame=CGRectMake(0,0,32,32)
        self.rightButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.rightButton!.frame=CGRectMake(0,0,ITEM_WIDTH,ITEM_HEIGHT)
        self.rightButton!.tag=10
        self.rightButton!.userInteractionEnabled = true
        self.rightButton?.addTarget(self, action: "rightBarButtonItemClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton!.setImage(UIImage(named: "searchCenter_d"),forState:UIControlState.Normal)
        self.rightButton!.setImage(UIImage(named: "searchCenter"),forState:UIControlState.Highlighted)
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
    
    var dynamicTableView:Dynamic!=nil
    var messageTableView:Message!=nil

    @IBAction func changeStatusClicked(sender: UIButton) {
        var btn_tag=sender.tag
        if(btn_tag == 20){
            println("加载动态消息")
            self.dynamic_btn.setTitleColor(UIColor.greenColor(),forState:UIControlState.Normal)
            self.message_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
            if(dynamicTableView == nil){
                dynamicTableView = UIStoryboard(name: "Dynamic", bundle: nil).instantiateViewControllerWithIdentifier("dynamicSb")as Dynamic
                dynamicTableView.view.frame = CGRect(x: 0, y: 0, width: container_v.frame.width, height: container_v.frame.height)
                dynamicTableView.NavigationController = self.navigationController
                container_v.addSubview(dynamicTableView.view)
            }else{
                println("缓存view")
                dynamicTableView.reloadData()
                //recipesCollection.ReloadData()
            }
            container_v.bringSubviewToFront(dynamicTableView.view)
        }else if(btn_tag == 30){
             
//            OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: 2)
            
            println("加载个人消息")
            self.message_btn.setTitleColor(UIColor.greenColor(),forState:UIControlState.Normal)
            self.dynamic_btn.setTitleColor(UIColor.lightGrayColor(),forState:UIControlState.Normal)
            
            if(messageTableView == nil){
                messageTableView = UIStoryboard(name: "Message", bundle: nil).instantiateViewControllerWithIdentifier("messageSb")as Message
                messageTableView.view.frame = CGRect(x: 0, y: 0, width: container_v.frame.width, height: container_v.frame.height)
                messageTableView.NavigationController = self.navigationController
                container_v.addSubview(messageTableView.view)
            } else {
                //messageTableView.reloadData()
                println("缓存view")
            }
            container_v.bringSubviewToFront(messageTableView.view)
    }
    }





}
