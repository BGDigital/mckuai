//
//  DynamicModule.swift
//  mckuai
//
//  Created by XingfuQiu on 14/12/1.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class DynamicModel: NSObject {
    var title: String!
    var name:String!
    var recommend:String!
    var time:String!
    var pic:String!
     
    init(name:String!,recommend:String!,time:String!,pic:String!){
        self.name = name
        self.recommend = recommend
        self.time = time
        self.pic = pic
    }
}
