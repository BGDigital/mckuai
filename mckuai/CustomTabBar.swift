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

    // 动态
    @IBOutlet var dynamicButton : UIButton!
    
    // 精选
    @IBOutlet var handPickerButton : UIButton!
    
    // 图片博客
    @IBOutlet var pictureButton : UIButton!
    
    // 音乐
    @IBOutlet var musicButton : UIButton!
    
    var changeTableDelegate : ChangeTableDelegate?
    /*
    self.dynamicButton.setImage(UIImage(named: "home_on"), forState: .Selected)
    self.handPickerButton.setImage(UIImage(named: "community_on"), forState: .Selected)
    self.pictureButton.setImage(UIImage(named: "chat_on"), forState: .Selected)
    self.musicButton.setImage(UIImage(named: "mine_on"), forState: .Selected)
    */
    
    @IBAction func changeTabBar(sender : UIButton) {
        
        if sender == dynamicButton{
            self.dynamicButton.selected = true
            
            self.handPickerButton.selected = false
            self.pictureButton.selected = false
            self.musicButton.selected = false
            
        } else if sender == handPickerButton {
            
            self.dynamicButton.selected = false
            self.handPickerButton.selected = true
            self.pictureButton.selected = false
            self.musicButton.selected = false
            
        } else if sender == pictureButton {
            self.dynamicButton.selected = false
            self.handPickerButton.selected = false
            self.pictureButton.selected = true
            self.musicButton.selected = false
    
        } else if sender == musicButton {
            self.dynamicButton.selected = false
            self.handPickerButton.selected = false
            self.pictureButton.selected = false
            self.musicButton.selected = true
        }

       changeTableDelegate!.changeIndex(sender.tag)
    }
    
    
  

}
