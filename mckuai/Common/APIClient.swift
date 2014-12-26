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
        "content": content
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
            "talkTitle": talkTitle
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
            "replyUserName": replyUserName
        ]
        self.Send("talk.do?act=replyTalk", parameters: dict)
    }
    
    /*
    act=followTalk&
    userId="+login_userId+"&  当前登录用户
    operUserId="+hostUserId+"&  楼主贴用户id
    isNew="+isNew+"& 是否是新帖
    forumId="+forumId+"& 版块id
    forumName="+forumName+"& 版块名字
    talkId="+hostTalkId+"& 楼主帖子id
    content="+encodeURIComponent(encodeURIComponent(talkContent))+"&   跟帖内容
    talkTitle="+encodeURIComponent(encodeURIComponent(hostTalkTitle)) 楼主帖子标题
    
    var act="act=replyTalk&
    userId="+login_userId+"&
    replyContext="+encodeURIComponent(encodeURIComponent(replyContext))+"&
    talkId="+data_itemId+"&
    replyId="+replyId_id+"&
    replyUserName="+encodeURIComponent(encodeURIComponent(replyUserName));
    //=========================
    
    func getLatestTopics(nodeID: NSString, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["node_id": nodeID]
        self.getJSONData("topics/show.json", parameters: dict, success: success, failure: failure)
    }
    
    func getReplies(topicID: NSString, success: (JSON) -> Void, failure: (NSError) -> Void) {
        let dict = ["topic_id": topicID]
        self.getJSONData("replies/show.json", parameters: dict, success: success, failure: failure)
    }
    
    func getNodes(success: (JSON) -> Void, failure: (NSError) -> Void) {
        self.getJSONData("nodes/all.json", parameters: nil, success: success, failure: failure)
    }
    */
}
