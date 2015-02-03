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
    

    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var useravatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    var user:JSON?{
        didSet{
            if let u = user{
                username.text = u["nike"].stringValue
                GTUtil.loadImage(u["headImg"].stringValue, callback: {
                    (img:UIImage?) in
                    if img != nil{
                        self.useravatar.image = img
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        
    }
    override func viewDidAppear(animated: Bool) {
        loadData()
    }
    func loadData(){
        var uid = appUserIdSave
        uid = 3
        
        if uid == nil || uid == 0  {
            self.navigationController?.popViewControllerAnimated(false)
        }
        APIClient.sharedInstance.getUserInfo(self.myview, uid: uid, success: {
            (data:JSON?) -> Void in
            if(data != nil && data!["state"].stringValue == "ok"){
                self.user = data!["dataObject"]["user"]
            }
            }, failure: {
                (err:NSError) -> Void  in
        })
    }
    
    

    class func loadProfile(ctl:UINavigationController){
        var profile = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("profile") as Profile
        ctl.pushViewController(profile, animated: true)
    }
    
    @IBAction func exit(){
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("appUserIdSave")
        appUserIdSave = nil
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func toNick(){
        Nickname.changeNickname(self.navigationController!,uname:user!["nike"].stringValue)
    }
    
    @IBAction func toPass(){
        Profile_Password.changePass(self.navigationController!)
    }
    @IBAction func toAvatar(){
        Avatar.changeAvatar(self.navigationController!,url:user!["headImg"].stringValue)
    }
}