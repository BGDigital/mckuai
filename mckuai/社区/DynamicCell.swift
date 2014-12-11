//
//  DynamicCell.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/19.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire

class DynamicCell: UITableViewCell {

    @IBOutlet weak var imgComm: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replyNum: UILabel!
  
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置不能选中
        self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //截取小数点后的数
    func getStr(str: Double) -> String {
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
    func compDate(beginStr: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = NSLocale(localeIdentifier: NSGregorianCalendar)
        let date = formatter.dateFromString(beginStr)
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
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue
        self.username.text = json["userName"].stringValue
        self.time.text = compDate(json["replyTime"].stringValue)
        self.replyNum.text = json["replyNum"].stringValue
        var url = json["mobilePic"].stringValue
        setImage(url)
    }
    
    //异步获取图片
    func setImage(url: String) {
        //println(url)
        if (url != "") {
            Alamofire.request(.GET, url).response() {
            (_, _, data, _) in
                if data != nil {
                    self.imgComm.image = UIImage(data: data! as NSData)
                } else {
                    self.imgComm.image = UIImage(named: "home_on")
                }
            }
        }
        
   
    }

}
