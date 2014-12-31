//
//  dynamicAddCell.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class DynamicAddCell:UITableViewCell {
    
    @IBOutlet weak var addTalkIcon: UIImageView!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var talkTitle: UILabel!
    @IBOutlet weak var forumName: UILabel!
    @IBOutlet weak var insertTime: UILabel!
    @IBOutlet weak var replyNum: UILabel!
    @IBOutlet weak var replyIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置不能选中
//        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(json: JSON) {
        self.talkTitle.text = json["talkTitle"].string
        self.forumName.text = json["forumName"].string
        var timeTemp = json["insertTime"].string
        self.insertTime.text = GTUtil.compDate(timeTemp!)
        self.replyNum.text = String(json["replyNum"].int!)
    }
}