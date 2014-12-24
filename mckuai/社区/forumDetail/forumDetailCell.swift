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
    @IBOutlet weak var img: UIImageView!

    
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
        if json["hasVideo"].int16Value == 1 {
            self.img.image = UIImage(named: "bankuai_video")
        } else {
            if json["hasImg"].int16Value == 1 {
                self.img.image = UIImage(named: "bankuai_img")
            }
        }
    }

}
