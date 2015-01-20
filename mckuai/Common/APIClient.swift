//
//  APIClient.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//


import UIKit

let APIRootURL = "http://118.144.83.145:8081/"

class APIClient {
   
    class var sharedInstance : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    
    //Post请求
    private func Send(path: NSString, parameters: [String : AnyObject]?, view: UIView, ctl:UINavigationController?) -> Void {
        if GTUtil.CheckNetBreak() {return}
            var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "发布中"
        
            Alamofire.request(.POST, APIRootURL + path, parameters: parameters).responseSwiftyJSON {
                (_, _, json, error) in
                println("\(APIRootURL + path)，Send Successfull!!  返回值：\(json)")
                if json["state"].stringValue == "ok" {
                    //UIAlertView(title: "提示", message: "发布成功", delegate: nil, cancelButtonTitle: "确定").show()
                    hud.hide(true)
                    GTUtil.showCustomHUD(view, title: "发布成功", imgName: "bankuai")
                    ctl?.popViewControllerAnimated(true)
                }
            }
    }
    
    //GET
    private func getJSONData(view: UIView, path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
        if GTUtil.CheckNetBreak() {return}
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "正在获取"

            Alamofire.request(.GET, APIRootURL + path, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                if let err = error? {
                    hud.hide(true)
                    GTUtil.showCustomHUD(view, title: "获取数据出错", imgName: "bankuai")
                    failure(err)
                } else {
                    hud.hide(true)
                    success(json)
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
                    GTUtil.showCustomHUD(view, title: "登录失败", imgName: "bankuai")
                    failure(err)
                } else {
                    hud.hide(true)
                    success(json)
                }
        }
    }
    //获取社区数据
    func getCommunityData(view: UIView, success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData(view, path: "zone.do?act=iphoneAll", parameters: nil, success: success, failure: failure)
    }
    
    //获取社区版块信息
    func getCommunityBankuaiData(view: UIView, forumID: String, page: String, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["forumId": forumID, "page": page]
        self.getJSONData(view, path: "zone.do?act=one", parameters: dict, success: success, failure: failure)
    }
    
    //获取首页数据
    func getHomePageData(view: UIView, success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData(view, path: "index.do?act=all", parameters: nil, success: success, failure: failure)
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
        self.Send("talk.do?act=addTalk", parameters: dict, view: parentView, ctl:ctl)
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
        self.Send("talk.do?act=followTalk", parameters: dict, view: parentView, ctl:ctl)
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
        self.Send("talk.do?act=replyTalk", parameters: dict, view: parentView, ctl:ctl)
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
        self.getJSONData(view, path: "user.do?act=dynamic", parameters: dict, success: success, failure: failure)
    }

}
