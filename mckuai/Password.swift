//
//  Password.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Profile_Password:UIViewController {
    
    @IBOutlet weak var old_pass: UITextField!
    @IBOutlet weak var new_pass: UITextField!
    @IBOutlet weak var ensure_pass: UITextField!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var barSize = self.navigationController?.navigationBar.frame
        var btnSave = UIBarButtonItem()
        btnSave.title = "保存"
        self.navigationItem.rightBarButtonItem = btnSave
        btnSave.target = self
        btnSave.action = Selector("save")
    }
    
    func save(){
        let oldpass = old_pass.text
        let newpass = new_pass.text
        let ensure = ensure_pass.text
        
        if oldpass == "" || newpass == "" || ensure == ""{
            UIAlertView(title: "提示", message: "密码不能为空", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        if newpass != ensure {
            UIAlertView(title: "提示", message: "两次密码输入不一致", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        let dic = [
        "flag":NSString(string: "password"),
        "userId":appUserIdSave,
        "old_password":oldpass,
        "new_password":newpass
        ]
        APIClient.sharedInstance.modifiyUserInfo(self.view, ctl: self.navigationController, param: dic, success: {
            (res:JSON?) in
            }, failure: {
                (NSError) in
        })
    }
    
    class func changePass(ctl:UINavigationController){
        var edit_pass = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("pass_edit") as Profile_Password
        
        ctl.pushViewController(edit_pass, animated: true)
    }
}