//
//  APIClient.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//


import UIKit
import Alamofire

//let APIRootURL = "http://221.237.152.39:8081/"
let APIRootURL = "http://118.144.83.145:8081/"

class APIClient {
   
    class var sharedInstance : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    //Post请求
    private func Send(path: NSString, parameters: [String : AnyObject]?) {
        Alamofire.request(.POST, APIRootURL + path, parameters: parameters)
    }
    //GET
    private func getJSONData(path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
        Alamofire.request(.GET, APIRootURL + path, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                if let err = error? {
                    failure(err)
                } else {
                    success(json)
                }
        }
    }
    
    //POST
    private func getJSONDataByPost(path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
        Alamofire.request(.POST, APIRootURL + path, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                if let err = error? {
                    failure(err)
                } else {
                    success(json)
                }
        }
    }
    //获取社区数据
    func getCommunityData(success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData("zone.do?act=all", parameters: nil, success: success, failure: failure)
    }
    
    //获取社区版块信息
    func getCommunityBankuaiData(forumID: String, page: String, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["forumId": forumID, "page": page]
        self.getJSONData("zone.do?act=one", parameters: dict, success: success, failure: failure)
    }
    
    //获取首页数据
    func getHomePageData(success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData("index.do?act=all", parameters: nil, success: success, failure: failure)
    }
    
    
    //发贴
    func SendPost(userId: Int, forumId: Int, forumName: NSString, talkTypeId: Int, talkTypeName: NSString, talkTitle: NSString, content: NSString) {
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
        self.Send("talk.do?act=addTalk", parameters: dict)
    }
    
    //跟贴
    func SendFollow(userId: Int, operUserId: Int, isNew: Int, forumId: Int, forumName: NSString, talkId: Int, content: NSString, talkTitle: NSString) {
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
        self.Send("talk.do?act=followTalk", parameters: dict)
    }
    
    //回复
    func SendReply(userId: Int, replyContext: NSString, talkId: Int, replyId: Int, replyUserName: NSString) {
        let dict = [
            "userId": userId,
            "replyContext": replyContext,
            "talkId": talkId,
            "replyId": replyId,
            "replyUserName": replyUserName,
            "device": "ios"
        ]
        self.Send("talk.do?act=replyTalk", parameters: dict)
    }
    

    //QQ登录
    func qqLoginByPost(accessToken:String,openId:String,nickName:String,gender:String,headImg:String,success: (JSON) -> Void, failure: (NSError) -> Void){
        let dict = [
            "accessToken": accessToken,
            "openId": openId,
            "nickName": nickName,
            "gender": gender,
            "headImg": headImg,
        ]
        self.getJSONDataByPost("user.do?act=login", parameters: dict, success: success, failure: failure)
    }
    //获取用户信息
    func getUserOneInfo()(userId: Int, page: Int, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["id": userId, "page": page]
        self.getJSONData("user.do?act=dynamic", parameters: dict, success: success, failure: failure)
    }

}
