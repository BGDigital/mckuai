//
//  messageCell.swift
//  mckuai
//
//  Created by 陈强 on 14/12/4.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class MessageCell:UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var talkTitle: UILabel!
    @IBOutlet weak var forumName: UILabel!
    @IBOutlet weak var insertTime: UILabel!
    @IBOutlet weak var replyNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置不能选中
        //        self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(json: JSON) {
        self.userName.text = json["userName"].string
        self.content.text = json["content"].string
        self.talkTitle.text = json["talkTitle"].string
        
        self.forumName.text = json["forumName"].string
        var timeTemp = json["insertTime"].string
        self.insertTime.text = GTUtil.compDate(timeTemp!)
        //            cell.insertTime.text = self.json["dataObject","message",indexPath.row,"insertTime"].string
        self.replyNum.text = String(json["replyNum"].int!)
        self.content.text = json["cont"].string
    }
}
