//
//  TabBarViewController.swift
//  smartmixer
//
//  Created by kingzhang on 8/24/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

protocol ChangeTableDelegate{
    func changeIndex ( index: Int)
}

class TabBarViewController: UIView {
    //
    @IBOutlet  var  recipeBtn : UIButton!
    @IBOutlet  var  materlBtn : UIButton!
    @IBOutlet  var  contanBtn : UIButton!
    @IBOutlet  var  userBtn : UIButton!
    @IBOutlet  var  settigBtn : UIButton!
    @IBOutlet var barView:UIView!
    
    func initSelected(){
        currentSelected = recipeBtn
        recipeBtn.setImage(UIImage(named: "home_on.png"), forState: UIControlState.Selected)
        materlBtn.setImage(UIImage(named: "community_on.png"), forState: UIControlState.Selected)
        contanBtn.setImage(UIImage(named: "chat_on.png"), forState: UIControlState.Selected)
        userBtn.setImage(UIImage(named: "mine_on.png"), forState: UIControlState.Selected)
        
        //设置阴影颜色，透明度，偏移量
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.35;
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        
    }
    
    var currentSelected:UIButton!
    //
    var changeTableDelegate : ChangeTableDelegate?
    @IBAction func changeTabBar(sender : UIButton)
    {
        if(sender.tag < 4){
            currentSelected.selected = false
            if(sender.tag == 0){
                currentSelected = recipeBtn
            } else if(sender.tag == 1){
                currentSelected = materlBtn
            } else if(sender.tag == 2){
                currentSelected = contanBtn
            } else if(sender.tag == 3){
                currentSelected = userBtn
            }
            currentSelected.selected = true
        }
        changeTableDelegate!.changeIndex(sender.tag)
    }
}
