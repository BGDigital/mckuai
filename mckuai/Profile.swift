//
//  Profile.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/3.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit
class Profile:UIViewController {
    
    @IBOutlet weak var useravatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {

    }

    class func loadProfile(ctl:UINavigationController){
        var profile = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("profile") as Profile
        ctl.pushViewController(profile, animated: true)
    }
    
    @IBAction func exit(){
        println("退出")
    }
    @IBAction func toNick(){
        Nickname.changeNickname(self.navigationController!)
    }
    
    @IBAction func toPass(){
        Profile_Password.changePass(self.navigationController!)
    }
    @IBAction func toAvatar(){
        Avatar.changeAvatar(self.navigationController!)
    }
}