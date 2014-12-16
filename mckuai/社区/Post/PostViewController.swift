//
//  PostViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/12/16.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var lastBtn1: UIButton!
    var lastBtn2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置版块的选中状态
    @IBAction func setBankuaiSelect(sender : UIButton) {
        //let tag = sender.tag
        sender.setBackgroundImage(UIImage(named: "post_big_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        sender.selected = true
        if lastBtn1 != nil {
            lastBtn1.selected = false
        }
        lastBtn1 = sender
        
        println("板块按钮tag:\(sender.tag)")
    }
    //设置类型的选中状态
    @IBAction func setTypeSelected(sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "post_small_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        sender.selected = true
        if lastBtn2 != nil {
            lastBtn2.selected = false
        }
        lastBtn2 = sender
        
        println("类型按钮tag:\(sender.tag)")
    }
    
    //发贴
    @IBAction func SendPost() {
        println("发帖")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
