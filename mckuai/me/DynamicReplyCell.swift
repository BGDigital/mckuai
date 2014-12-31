//
//  DynamicReplyCell.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class DynamicReplyCell:UITableViewCell {
    

    @IBOutlet var replyName: UILabel!
    @IBOutlet var replyContent: UILabel!
    @IBOutlet var talkTitle: UILabel!
    
    @IBOutlet var forumName: UILabel!
    @IBOutlet var insertTime: UILabel!
    @IBOutlet var replyNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置不能选中
//        self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(json: JSON) {
        self.replyName.text = json["operUserName"].string
        self.replyContent.text = json["cont"].string
        self.talkTitle.text = json["talkTitle"].string
        self.forumName.text = json["forumName"].string
        var timeTemp = json["insertTime"].string
        self.insertTime.text = GTUtil.compDate(timeTemp!)
        self.replyNum.text = String(json["replyNum"].int!)
    }
}
