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
    
    class var sharedInstance : AppContext {
    struct Static {
        static let instance : AppContext = AppContext()
        }
        return Static.instance
    }
    //缓存全部社区信息
    func saveCommunityData(nodes:AnyObject) {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(nodes), forKey: kCommunityKey)
        userDefaults.synchronize()
    }
    
    func getCommunityData() -> JSON? {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var data: AnyObject? = userDefaults.objectForKey(kCommunityKey)
        if let obj: AnyObject = data? {
            var json: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(obj as NSData)
            return JSON(json!)
        } else {
            return nil
        }
    }
    
}
