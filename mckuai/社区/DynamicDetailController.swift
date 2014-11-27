//
//  DynamicDetailController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/19.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class DynamicDetailController: UIViewController {
    var titleName:String!
    var address:String!
    
    override func viewDidLoad() {
        self.title = titleName
    }

}
