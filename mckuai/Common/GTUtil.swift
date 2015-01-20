//
//  Utils.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/15.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class GTUtil {
    class func loadImageView(#img:UIImageView,url:String){
        if (url != "") {
            Alamofire.request(.GET, url).response() {
                (_, _, data, _) in
                if data != nil {
                    img.image = UIImage(data: data! as NSData)
                } else {
                    img.image = UIImage(named: "bankuai_faild")
                }
            }
        }
    }
    
    class func showCustomHUD(view: UIView, title: String, imgName: String) {
        var h = MBProgressHUD.showHUDAddedTo(view, animated: true)
        h.labelText = title
        h.mode = MBProgressHUDModeCustomView
        h.customView = UIImageView(image: UIImage(named: imgName))
        h.showAnimated(true, whileExecutingBlock: { () -> Void in
            sleep(2)
            return
        }) { () -> Void in
            h.removeFromSuperview()
            h = nil
        }
    }
    
    class func CheckNetBreak() -> Bool {
        //判断网络是已连接
        if !Reachability.isConnectedToNetwork() {
            SweetAlert().showAlert("出错啦", subTitle: "检查一下流量开关或连上WiFi再试试", style: AlertStyle.Warning, buttonTitle:"", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "知道了", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    println("Cancel Button  Pressed")
                }
                else {
                    //                    SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
                }
            }
            //网络不可用
            return true
        } else {
            //网络可用
            return false
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
            return "\(s)分钟前"
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
    
    //这个是轮播图用的
    //也可以用于加载一个UIimage对象
    class func loadImage(url:String,callback:(UIImage?) -> Void){
        if(url != ""){
            Alamofire.request(.GET, url).response() {
                (_, _, data, _) in
                if data != nil {
                    callback(UIImage(data: data! as NSData))
                }
            }
        }
    }
    //将url 的querystring 分离成dictionary
    
    class func getQueryDictionary(query:String) -> [String:String]{
        var components = query.componentsSeparatedByString("&")
        var rs = [String:String]()
        
        
        for p in components {
            var tmp = p.componentsSeparatedByString("=")
            if tmp.count < 2 {
                continue
            }
            var key = tmp[0]
            var val = tmp[1]
            rs[key] = val
        }
        
        return rs
    }
}