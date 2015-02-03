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
    
    var chosedAvatar:String?{
        didSet{
            choseAvatar()
        }
    }
    var avatars = [
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg",
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg",
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg",
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg",
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg",
        "http://pic3.zhimg.com/3d6543642_m.jpg",
        "http://pic4.zhimg.com/f0d75f67542d7447612ebac5f67d208c_m.jpg",
        "http://pic1.zhimg.com/88db1114b_m.jpg"
    ]
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var avatarList: UICollectionView!
    override func viewDidLoad() {
        
        chosedAvatar = avatars[0]
        
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
        if(chosedAvatar != nil){
            println(chosedAvatar!)
        }
    }
    func choseAvatar(){
        if(chosedAvatar == nil){
            return
        }
        GTUtil.loadImage(chosedAvatar!, callback: {
            (img:UIImage?)->Void in
            self.avatar.image = img
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        chosedAvatar = avatars[indexPath.row]
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.frame.size.height = CGFloat(50 * avatars.count)
        return avatars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var chosing = collectionView.dequeueReusableCellWithReuseIdentifier("avt", forIndexPath: indexPath) as AvatarHolder
        chosing.url = avatars[indexPath.row]
        return chosing
    }
    
    
    class func changeAvatar(ctl:UINavigationController){
        var avatar_view = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("avatar_chose") as Avatar
        
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