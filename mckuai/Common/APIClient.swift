//
//  APIClient.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

import UIKit
import Alamofire

let APIRootURL = "http://221.237.152.39:8081/"

class APIClient {
   
    class var sharedInstance : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    
    func getJSONData(path: NSString, parameters: [String : AnyObject]?, success: (JSON) -> Void, failure: (NSError) -> Void) {
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
    
    /*
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
