//
//  AppContext.swift
//  v2ex
//
//  Created by liaojinxing on 14/10/21.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

import UIKit

class AppContext {
   
    private let kCommunityKey = "communityData"
    private let kHomepageKey = "homepageData"
    
    class var sharedInstance : AppContext {
    struct Static {
        static let instance : AppContext = AppContext()
        }
        return Static.instance
    }
    //缓存全部社区信息
    func saveCommunityData(nodes:AnyObject) {
        saveData(key: kCommunityKey,nodes: nodes)
    }
    
    func getCommunityData() -> JSON? {
        return getData(key: kCommunityKey)
    }
    
    //缓存首页数据
    func saveHomePageData(nodes:AnyObject){
        saveData(key: kHomepageKey , nodes: nodes)
    }
    
    func getHomePageData() ->JSON?{
        return getData(key:kHomepageKey)
    }
    
    private func saveData(#key:String,nodes:AnyObject){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(nodes), forKey: key)
            userDefaults.synchronize()
            
        })
        
    }
    
    private func getData(#key:String) -> JSON{
        
            var userDefaults = NSUserDefaults.standardUserDefaults()
            var data: AnyObject? = userDefaults.objectForKey(key)
            if let obj: AnyObject = data? {
                var json: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(obj as NSData)
                return JSON(json!)
            } else {
                return nil
            }
    }
    
}
