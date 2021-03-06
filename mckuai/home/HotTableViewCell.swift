//
//  HotTableViewCell.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/9.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class HotTableViewCell:UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var countReply: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bankuai: UILabel!
   
    
    func update(json:JSON){
        self.selectionStyle = .None
        
        title.text = json["talkTitle"].stringValue+"\n "
        
        bankuai.text = json["forumName"].stringValue
     
        time.text = GTUtil.compDate(json["replyTime"].stringValue)//要用分钟数
        
        countReply.text = json["replyNum"].stringValue
//        countReply.sizeToFit()
        
 //       var src = "http://pic.youxigt.com/uploadimg/quan/images1/41501413785977713.png"
        var src = json["mobilePic"].stringValue
        //loadImg(src)
        GTUtil.loadImageView(img: self.pic, url: src)
    }
    
}