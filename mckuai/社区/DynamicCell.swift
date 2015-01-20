//
//  DynamicCell.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/19.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class DynamicCell: UITableViewCell {

  
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var replynum: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置不能选中
        //self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(json: JSON) {
        self.title.text = json["name"].stringValue+"\n "
        self.desc.text = json["shortDres"].stringValue
        self.replynum.setTitle(json["talkNum"].stringValue, forState: .Normal)
        var url = json["icon"].stringValue
        setImage(url)
    }
    
    //异步获取图片
    func setImage(url: String) {
        //println(url)
        if (url != "") {
            Alamofire.request(.GET, url).response() {
            (_, _, data, _) in
                if data != nil {
                    self.img.image = UIImage(data: data! as NSData)
                } else {
                    self.img.image = UIImage(named: "home_on")
                }
            }
        }
        
   
    }

}
