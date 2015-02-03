//
//  Nickname.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Nickname:UIViewController {
    
    @IBOutlet weak var nick_editor: UITextField!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var barSize = self.navigationController?.navigationBar.frame
        var btnSave = UIBarButtonItem()
        btnSave.title = "保存"
        self.navigationItem.rightBarButtonItem = btnSave
        btnSave.target = self
        btnSave.action = Selector("save")
        nick_editor.layer.borderColor = UIColor.whiteColor().CGColor

        
    }
    class func changeNickname(ctl:UINavigationController){
        var edit_nick = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("edit_nick") as Nickname
        
        ctl.pushViewController(edit_nick, animated: true)
    }
    func save(){
       println(nick_editor.text)
    }
}