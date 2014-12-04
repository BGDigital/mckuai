//
//  CollectionViewCell.swift
//  test
//
//  Created by XingfuQiu on 14/11/27.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var talkNum: UIButton!
    @IBOutlet weak var caption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(json: JSON) {
        self.talkNum.setTitle(json["talkNum"].stringValue, forState: .Normal)
        self.caption.text = json["name"].stringValue
        var url = json["icon"].stringValue
        
        url = "http://pic.youxigt.com/uploadimg/quan/images1/68831411547537743.jpg"
        setImage(url)
    }
    
    //异步获取图片
    func setImage(url: String) {
            Alamofire.request(.GET, url).response() {
                (_, _, data, error) in
                if error == nil
                {
                    if data != nil {
                        self.imageView.image = UIImage(data: data! as NSData)
                    } else {
                        self.imageView.image = UIImage(named: "home_on")
                    }
                }
            }
 
    }
}
