//
//  FilletButton.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-8-22.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit

@IBDesignable class FilletButton: UIButton {
    
    
    //选中时的显示文字
    @IBInspectable var selectedTitle:String = ""{
        didSet{
            self.setTitle(selectedTitle, forState: UIControlState.Selected)
        }
    }
    
    
    //按钮的边框颜色
    @IBInspectable var borderColor:UIColor = UIColor.grayColor(){
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }
    
    //按钮的边框颜色
    @IBInspectable var borderSelectedColor:UIColor?
    
    //按钮的边框宽度
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    //按钮的圆角圆度
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    //普通时候的背景颜色
    @IBInspectable var normalbgColor:UIColor = UIColor.grayColor(){
        didSet{
            if(super.selected == false){
                self.backgroundColor = normalbgColor
            }
        }
    }
    
    //选中时候的背景颜色
    @IBInspectable var selectedbgColor:UIColor = UIColor.grayColor()
    
    
    //普通时候的字体颜色
    @IBInspectable var normalfontColor:UIColor = UIColor.whiteColor(){
        didSet{
            self.setTitleColor(normalfontColor, forState: UIControlState.Normal)
        }
    }
    
    //选中时候的字体颜色
    @IBInspectable var selectedfontColor:UIColor = UIColor.whiteColor(){
        didSet{
            self.setTitleColor(selectedfontColor, forState: UIControlState.Selected)
        }
    }
    
    
    //选中时候的颜色
    override var selected:Bool{
        set(newValue){
            super.selected = newValue
            if newValue {
                self.backgroundColor = selectedbgColor
                if(borderSelectedColor != nil){
                    self.layer.borderColor = self.borderSelectedColor?.CGColor
                }
                
            }else{
                self.backgroundColor = normalbgColor
                if(borderSelectedColor != nil){
                    self.layer.borderColor = self.borderColor.CGColor
                }
            }
        }
        get{
            return super.selected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.addTarget(self, action: "clickbutton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /*
    override func didChangeValueForKey(key: String!) {
        super.didChangeValueForKey(key)
        if(key == "selected"){
            NSLog("按钮触发了点击操作\(self.selected)")
        }
        
    }
*/
    
    func clickbutton(sender:UIButton){
        NSLog("按钮触发了点击操作\(self.selected)")
        /*
        if self.selected {
            self.backgroundColor = selectedbgColor
        }else{
            self.backgroundColor = normalbgColor
        }
*/
    }
    
}