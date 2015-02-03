//
//  APIClient.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//


import UIKit

//let APIRootURL = "http://118.144.83.145:8081/"
let APIRootURL = "http://192.168.10.102/"
class APIClient {
   
    class var sharedInstance : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    
    //Post请求
    private func Send(path: NSString, parameters: [String : AnyObject]?, view: UIView, ctl:UINavigationController?, isOver: String) -> Void {
        if GTUtil.CheckNetBreak() {return}
            var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "发布中"
        
            Alamofire.request(.POST, APIRootURL + path, parameters: parameters).responseSwiftyJSON {
                (_, _, json, error) in
                println("\(APIRootURL + path)，Send Successfull!!  返回值：\(json)")
                if json["state"].stringValue == "ok" {
                    //UIAlertView(title: "提示", message: "发布成功", delegate: nil, cancelButtonTitle: "确定").show()
                    hud.hide(true)
                    GTUtil.showCustomHUD(view, title: "发布成功", imgName: "HUD_OK")
                    ctl?.popViewControllerAnimated(true)
                            if isOver == "yes" {
                                println("调用xyz的刷新JS，刷新页面！")
                                (ctl?.topViewController as TieziController).afterReply()
                            }

                }
            }
    }
    
    //GET
    private func getJSONData(showHud: Bool, view: UIView, path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
        if GTUtil.CheckNetBreak() {return}
        if showHud {
            var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "正在获取"
            Alamofire.request(.GET, APIRootURL + path, parameters: parameters)
                .responseSwiftyJSON { (request, response, json, error) in
                    if let err = error? {
                        hud.hide(true)
                        GTUtil.showCustomHUD(view, title: "获取数据出错", imgName: "HUD_ERROR")
                        failure(err)
                    } else {
                        hud.hide(true)
                        success(json)
                    }
            }
        } else {
        
            Alamofire.request(.GET, APIRootURL + path, parameters: parameters)
                .responseSwiftyJSON { (request, response, json, error) in
                    if let err = error? {
                        
                        GTUtil.showCustomHUD(view, title: "获取数据出错", imgName: "HUD_ERROR")
                        failure(err)
                    } else {
                        
                        success(json)
                    }
            }
        }
        
 
    }
    
    //POST
    private func getJSONDataByPost(view: UIView, path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
        if GTUtil.CheckNetBreak() {return}
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "登录中"

        Alamofire.request(.POST, APIRootURL + path, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                if let err = error? {
                    hud.hide(true)
                    GTUtil.showCustomHUD(view, title: "登录失败", imgName: "HUD_ERROR")
                    failure(err)
                } else {
                    hud.hide(true)
                    success(json)
                }
        }
    }
    //获取社区数据
    func getCommunityData(showHud: Bool,view: UIView, success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData(showHud, view: view, path: "zone.do?act=iphoneAll", parameters: nil, success: success, failure: failure)
    }
    
    //获取社区版块信息
    func getCommunityBankuaiData(showHUD: Bool, view: UIView, forumID: String, page: String, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["forumId": forumID, "page": page]
        self.getJSONData(showHUD, view: view, path: "zone.do?act=one", parameters: dict, success: success, failure: failure)
    }
    
    //获取首页数据
    func getHomePageData(showHUD: Bool, view: UIView, success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData(showHUD, view: view, path: "index.do?act=all", parameters: nil, success: success, failure: failure)
    }
    
    
    //发贴
    func SendPost(ctl:UINavigationController?, parentView: UIView, userId: Int, forumId: Int, forumName: NSString, talkTypeId: Int, talkTypeName: NSString, talkTitle: NSString, content: NSString) -> Void {
        let dict = [
        "userId": userId,
        "forumId": forumId,
        "forumName": forumName,
        "talkTypeId": talkTypeId,
        "talkTypeName": talkTypeName,
        "talkTitle": talkTitle,
        "content": content,
        "device": "ios"
        ]
        self.Send("talk.do?act=addTalk", parameters: dict, view: parentView, ctl:ctl, isOver:"false")
    }
    
    //跟贴
    func SendFollow(ctl:UINavigationController?, parentView: UIView, userId: Int, operUserId: Int, isNew: Int, forumId: Int, forumName: NSString, talkId: Int, content: NSString, talkTitle: NSString) -> Void {
        let dict = [
            "userId": userId,
            "operUserId": operUserId,
            "isNew": isNew,
            "forumId": forumId,
            "forumName": forumName,
            "talkId": talkId,
            "content": content,
            "talkTitle": talkTitle,
            "device": "ios"
        ]
        self.Send("talk.do?act=followTalk", parameters: dict, view: parentView, ctl:ctl, isOver:"yes")
    }
    
    //回复
    func SendReply(ctl:UINavigationController?, parentView: UIView, userId: Int, replyContext: NSString, talkId: Int, replyId: Int, replyUserName: NSString) -> Void {
        let dict = [
            "userId": userId,
            "replyContext": replyContext,
            "talkId": talkId,
            "replyId": replyId,
            "replyUserName": replyUserName,
            "device": "ios"
        ]
        self.Send("talk.do?act=replyTalk", parameters: dict, view: parentView, ctl:ctl, isOver:"yes")
    }
    

    //QQ登录
    func qqLoginByPost(view: UIView, accessToken:String,openId:String,nickName:String,gender:String,headImg:String,success: (JSON) -> Void, failure: (NSError) -> Void){
        let dict = [
            "accessToken": accessToken,
            "openId": openId,
            "nickName": nickName,
            "gender": gender,
            "headImg": headImg,
        ]
        self.getJSONDataByPost(view, path: "user.do?act=login", parameters: dict, success: success, failure: failure)
    }
    //获取用户信息
    func getUserOneInfo(view: UIView, userId: Int, page: Int, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["id": userId, "page": page]
        self.getJSONData(false, view: view, path: "user.do?act=dynamic", parameters: dict, success: success, failure: failure)
    }
    
    //QQ登录
    func mckuaiLoginByPost(view: UIView, userName:String,passWord:String,success: (JSON) -> Void, failure: (NSError) -> Void){
        let dict = [
            "userName": userName,
            "passWord": passWord,
        ]
        self.getJSONDataByPost(view, path: "user.do?act=userLogin", parameters: dict, success: success, failure: failure)
    }
    
    //QQ注册
    func mckuaiRegisterByPost(view: UIView, userName:String,passWord:String,nickName:String,success: (JSON) -> Void, failure: (NSError) -> Void){
        let dict = [
            "userName": userName,
            "passWord": passWord,
            "nickName": nickName,
        ]
        self.getJSONDataByPost(view, path: "user.do?act=register", parameters: dict, success: success, failure: failure)
    }

    func getUserInfo(view: UIView,uid:Int,success: (JSON) -> Void, failure: (NSError) -> Void){
        var api = "user.do?act=one"
        self.getJSONData(true, view: view, path: api, parameters: ["id":uid], success: success, failure: failure)
    }
    
    func modifiyUserInfo(view:UIView,ctl:UINavigationController?,param:[String : AnyObject]?,success: (JSON) -> Void, failure: (NSError) -> Void){
        var api = "user.do?act=update"
        
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "保存中"
        
        Alamofire.request(.GET, APIRootURL + api, parameters: param).responseSwiftyJSON {
            (_, _, json, error) in
//            println(APIRootURL + api)
//            println(param)
//            println(json)
            hud.hide(true)
            if json["state"].stringValue == "ok" {
                GTUtil.showCustomHUD(view, title: "保存成功", imgName: "HUD_OK")
                ctl?.popViewControllerAnimated(true)
            }else{
                GTUtil.showCustomHUD(view, title: json["msg"].stringValue , imgName: "HUD_OK")
            }
        }
    }
}
