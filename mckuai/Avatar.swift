//
//  avatar.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Avatar:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    var imgPrex = "http://cdn.mckuai.com/images/iphone/"
    var isNew = false
    var chosedAvatar:String?{
        didSet{
            choseAvatar()
        }
    }
    var avatars = ["0.png","1.png","2.png","3.png","4.png","5.png","6.png","7.png","8.png","9.png","10.png","11.png","12.png","13.png","14.png"]
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var avatarList: UICollectionView!
    override func viewDidLoad() {

        if chosedAvatar == nil {
            chosedAvatar = avatars[0]
        }else{
            choseAvatar()
        }
        
        avatarList.dataSource = self
        avatarList.delegate = self
        avatarList.scrollEnabled = false
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var barSize = self.navigationController?.navigationBar.frame
        var btnSave = UIBarButtonItem()
        btnSave.title = "保存"
        self.navigationItem.rightBarButtonItem = btnSave
        btnSave.target = self
        btnSave.action = Selector("save")
    }
    func save(){
        if !isNew {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        if(chosedAvatar != nil){
            let dic = [
                "flag" : NSString(string: "headImg"),
                //                "userId": appUserIdSave,
                "userId": 3,
                "headImg" : chosedAvatar!
            ]
            APIClient.sharedInstance.modifiyUserInfo(self.view, ctl: self.navigationController, param: dic, success: {
                (res:JSON?)in
                }, failure: {
                    (res:NSError) in
            })
            
        }
    }
    func choseAvatar(){
        if chosedAvatar == nil || self.avatar == nil {
            return
        }

        var a_url = chosedAvatar!.hasPrefix("http://") ? chosedAvatar! : imgPrex + chosedAvatar!

        GTUtil.loadImage( a_url, callback: {
            (img:UIImage?)->Void in
            self.avatar.image = img
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        chosedAvatar = avatars[indexPath.row]
        isNew = true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.frame.size.height = CGFloat(50 * avatars.count)
        return avatars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var chosing = collectionView.dequeueReusableCellWithReuseIdentifier("avt", forIndexPath: indexPath) as AvatarHolder
        chosing.url = imgPrex + avatars[indexPath.row]
        return chosing
    }
    
    
    class func changeAvatar(ctl:UINavigationController,url:String?){
        var avatar_view = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("avatar_chose") as Avatar
        avatar_view.chosedAvatar = url
        ctl.pushViewController(avatar_view, animated: true)
    }
    
}

class AvatarHolder:UICollectionViewCell{
    
    @IBOutlet weak var holder: UIImageView!
    var url:String?{
        didSet{
            GTUtil.loadImage(url!, callback: {
                (img:UIImage?)->Void in
                self.holder.image = img
            })
        }
    }
    
}