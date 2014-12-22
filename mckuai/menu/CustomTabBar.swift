//
//  CustomTabBar.swift
//  DreamWorld
//
//  Created by imac on 14-6-12.
//  Copyright (c) 2014年 imac. All rights reserved.
//

import UIKit

protocol ChangeTableDelegate{
    
    func changeIndex(index:Int)
}

class CustomTabBar: UIView {
    
    @IBOutlet weak var btn_home: UIButton!
    @IBOutlet weak var btn_community: UIButton!
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var btn_mine: UIButton!
    
    var changeTableDelegate : ChangeTableDelegate?
    
    @IBAction func changeTabBar(sender : UIButton) {
        
        if sender == btn_home{
            self.btn_home.selected = true
            
            self.btn_community.selected = false
            self.btn_chat.selected = false
            self.btn_mine.selected = false
            
        } else if sender == btn_community {
            
            self.btn_home.selected = false
            self.btn_community.selected = true
            self.btn_chat.selected = false
            self.btn_mine.selected = false
            
        } else if sender == btn_chat {
            self.btn_home.selected = false
            self.btn_community.selected = false
            self.btn_chat.selected = true
            self.btn_mine.selected = false
            
        } else if sender == btn_mine {
            self.btn_home.selected = false
            self.btn_community.selected = false
            self.btn_chat.selected = false
            self.btn_mine.selected = true
        }
        
        changeTableDelegate!.changeIndex(sender.tag)
    }
    
    
  

}
