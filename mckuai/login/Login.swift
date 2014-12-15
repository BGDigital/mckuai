//
//  Login.swift
//  mckuai
//
//  Created by 陈强 on 14/12/10.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire
class Login: UIViewController,TencentSessionDelegate{
    
    var tencentOAuth:TencentOAuth!
    var permissionsArray=["get_user_info"]
    var http_url = UserCenterUrl;
    var json: JSON!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var in_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        tencentOAuth = TencentOAuth(appId: "101155101", andDelegate: self)
        tencentOAuth.authorize(permissionsArray,inSafari:false)
        
    }
    func tencentDidLogin(){
        if (tencentOAuth.accessToken != nil)
        {
            println(tencentOAuth.accessToken)
            println(tencentOAuth.openId)
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
        var userInfo = response.jsonResponse;
        var accessToken = tencentOAuth.accessToken
        var openId = tencentOAuth.openId
        var nickName:String = userInfo["nickname"] as String!
        var gender:String = userInfo["gender"] as String!
        var headImg:String = userInfo["figureurl_qq_2"] as String!
        
        var paramDictionary :Dictionary<String,String> = ["act":"login","accessToken":accessToken,"openId":openId,"nickName":nickName,"gender":gender,"headImg":headImg]
        
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    var alertView = UIAlertView(title: "登录提示框", message: "登录失败!请稍候再试", delegate: self, cancelButtonTitle: "确定")
                    alertView.show()
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    var state = self.json["state"].string
                    var userId = self.json["dataObject"].int
                    if(state == "ok") {
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "appUserIdSave")
                        appUserIdSave = userId!
                        UIView.animateWithDuration(0.3,
                            animations : {
                                self.view.alpha = 0
                            },
                            completion : {_ in
                                self.view.removeFromSuperview()
                                //                    self.dismissViewControllerAnimated(false, completion: nil)
                            }
                        )
                    }else {
                        var alertView = UIAlertView(title: "登录提示框", message: "登录失败!请稍候再试", delegate: self, cancelButtonTitle: "确定")
                        alertView.show()
                    }
                }
        }

    }

    @IBAction func inAction(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            animations : {
                self.view.alpha = 0
            },
            completion : {_ in
                    self.view.removeFromSuperview()
//                    self.dismissViewControllerAnimated(false, completion: nil)
            }
        )

    }
}