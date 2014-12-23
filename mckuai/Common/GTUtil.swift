//
//  Utils.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/15.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class GTUtil {
    class func loadImageView(#img:UIImageView,url:String){
        if (url != "") {
            Alamofire.request(.GET, url).response() {
                (_, _, data, _) in
                if data != nil {
                    img.image = UIImage(data: data! as NSData)
                } else {
                    img.image = UIImage(named: "home_on")
                }
            }
        }
    }
    
    //截取小数点后的数
    class func getStr(str: Double) -> String {
        let d = "\(str)"
        var result = ""
        for character in d {
            if (character == ".") {
                break
            } else {
                result = result+"\(character)"
            }
        }
        if result.toInt() == 0 {
            return "1"
        } else {
            return result
        }
    }
    
    //计算时间差
    class func compDate(beginStr: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = NSLocale(localeIdentifier: NSGregorianCalendar)
        let date = formatter.dateFromString(beginStr)
        if date == nil {
            return "时间格式出错"
        }
        var second:NSTimeInterval
        second = -date!.timeIntervalSinceNow
        if second < 60 {
            return "刚刚"
        } else if (second/60) < 60 {
            var tmp = second/60
            var s = getStr(tmp)
            return "\(s) 分钟前"
        } else if (second/60/60) < 24 {
            var tmp = second/60/60
            var s = getStr(tmp)
            return "\(s)小时前"
        } else if (second/60/60/24) < 30 {
            var tmp = second/60/60/24
            var s = getStr(tmp)
            return "\(s)天前"
        } else if (second/60/60/24/30) < 12 {
            var tmp = second/60/60/24/30
            var s = getStr(tmp)
            return "\(s)月前"
        } else {
            var tmp = second/60/60/24/30/12
            var s = getStr(tmp)
            return "\(s)年前"
        }
    }
    
    class func loadImage(url:String,callback:(UIImage) -> Void){
        if(url != ""){
            Alamofire.request(.GET, url).response() {
                (_, _, data, _) in
                if data != nil {
                    callback(UIImage(data: data! as NSData)!)
                }
            }
        }
    }
}