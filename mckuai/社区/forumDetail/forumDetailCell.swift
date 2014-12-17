//
//  forumDetailCell.swift
//  test
//
//  Created by XingfuQiu on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Foundation

class forumDetailCell: UITableViewCell {

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replyNum: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }  
    
    func update(json: JSON) {
        self.caption.text = json["talkTitle"].stringValue
        self.username.text = json["userName"].stringValue
        self.time.text = GTUtil.compDate(json["replyTime"].stringValue)
        self.replyNum.setTitle(json["replyNum"].stringValue, forState: UIControlState.Normal)
    }

}
