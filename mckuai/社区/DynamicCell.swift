//
//  DynamicCell.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/19.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

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
        //self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue+"\n "
        self.username.text = json["userName"].stringValue
        self.time.text = GTUtil.compDate(json["replyTime"].stringValue)
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
