//
//  McLogin.swift
//  mckuai
//
//  Created by 陈强 on 14/12/26.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class McLogin: UIViewController,TencentSessionDelegate {
    
    var tencentOAuth:TencentOAuth!
    var permissionsArray=["get_user_info"]
    
    var json: JSON!

    
    @IBOutlet weak var cancleLogin: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancleLogin.setBackgroundImage(UIImage(named: "new_back"), forState: UIControlState.Normal)
        cancleLogin.setBackgroundImage(UIImage(named: "new_back_press"), forState: UIControlState.Highlighted)
        
        loginBtn.setBackgroundImage(UIImage(named: "new_login"), forState: UIControlState.Normal)
        loginBtn.setBackgroundImage(UIImage(named: "new_login_press"), forState: UIControlState.Highlighted)//按下去时,selected被选中时
        
        tencentOAuth = TencentOAuth(appId: tencentAppKey, andDelegate: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginAction(sender: UIButton) {
        if(sender.tag == 1){
            removeLoginView()
        }else if(sender.tag == 2){
            tencentOAuth.authorize(permissionsArray,inSafari:false)
            
        }
    
    }
    
    func removeLoginView() {
        UIView.animateWithDuration(0.3,
            animations : {
                self.view.alpha = 0
            },
            completion : {_ in
                self.view.removeFromSuperview()
            }
        )
        
    }
    
    func tencentDidLogin(){
        if (tencentOAuth.accessToken != nil)
        {
            tencentOAuth.getUserInfo()
        }else
        {
            println("登录不成功 没有获取accesstoken");
        }
    }
    
    func tencentDidNotLogin(cancelled:Bool){
        if (cancelled){
            println("用户取消登录")
        }else{
            println("登录失败")
        }
    }
    
    func tencentDidNotNetWork(){
        println("无网络连接，请设置网络")
    }
    
    func getUserInfoResponse(response:APIResponse){
        if(response.retCode == 0){
            var userInfo = response.jsonResponse;
            var accessToken = tencentOAuth.accessToken as String!
            var openId = tencentOAuth.openId as String!
            var nickName:String = userInfo["nickname"] as String!
            var gender:String = userInfo["gender"] as String!
            var headImg:String = userInfo["figureurl_qq_2"] as String!
            println(nickName)
            APIClient.sharedInstance.qqLoginByPost(accessToken, openId: openId, nickName: nickName, gender: gender, headImg: headImg,success: { (json) -> Void in
                println(json)
                if json["state"].stringValue == "ok" {
                    println("从服务器登录成功")
                    var userId = json["dataObject"].intValue
                    //保存登录信息
                    var userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setInteger(userId, forKey: "appUserIdSave")
                    userDefault.synchronize()
                    
                    appUserIdSave = userId
                    self.removeLoginView()
                    
                }else{
                    var alertView = UIAlertView(title: "登录失败!请稍候再试", message: "", delegate: self, cancelButtonTitle: "确定")
                    alertView.show()
                }
                
                }, failure: { (error) -> Void in })
        }else{
            println(response.errorMsg)
        }

        
    }
    
    
    class func showLoginView(prentView:UIViewController){
        loginView=UIStoryboard(name:"McLogin",bundle:nil).instantiateViewControllerWithIdentifier("mcLogin") as McLogin
        prentView.view.addSubview(loginView.view)
        //prentView.presentViewController(loginView, animated: true, completion: nil)

    }
    
    
    
}