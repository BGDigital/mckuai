//
//  OtherCenter.swift
//  mckuai
//
//  Created by 陈强 on 14/12/28.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import Foundation

class OtherCenter: UIViewController{
    
    var userId = 0
    var page = 1
    var getData = JSON("")
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var shen: UILabel!
    @IBOutlet weak var mingren: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var level: UILabel!
    
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var dynamicTableView:Dynamic!=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        if(dynamicTableView == nil){
            dynamicTableView = UIStoryboard(name: "Dynamic", bundle: nil).instantiateViewControllerWithIdentifier("dynamicSb")as Dynamic
            dynamicTableView.userId = self.userId
            dynamicTableView.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            dynamicTableView.NavigationController = self.navigationController
            containerView.addSubview(dynamicTableView.view)
        }else{
            println("缓存view")
        }
        containerView.bringSubviewToFront(dynamicTableView.view)
        
    }
    func initData(){
        APIClient.sharedInstance.getUserOneInfo(self.view, userId: userId, page: page, success: { (json) -> Void in
            self.getData = json
            println(self.getData)
            if self.getData["state"].stringValue == "ok" {
                println("获取他人消息成功")
                
                var url = self.getData["dataObject","user","headImg"].string!
                GTUtil.loadImageView(img: self.headImg, url: url)
                self.userName.text = self.getData["dataObject","user","nike"].string
                self.level.text = "LV."+String(self.getData["dataObject","user","level"].int!)
                var isServerActor = self.getData["dataObject","user","isServerActor"].int
                
                if(isServerActor == 1){
                    self.shen.text = "腐"
                    self.mingren.hidden = true
                } else if(isServerActor == 2){
                    self.shen.text = "名"
                    self.mingren.hidden = true
                } else {
                    self.mingren.hidden = true
                    self.shen.hidden = true
                }
                
                
            }else{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            }, failure: { (error) -> Void in })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//    
//     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        let j = self.getData["dataObject","dynamic"] as JSON
//        if (j != nil) {
//            return j.count
//        }
//        return 0
//        //return self.json["dataObject","dynamic"].count
//    }
//    
//     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var getType = self.getData["dataObject","dynamic",indexPath.row,"type"].string
//        if(getType == "talk_add") {
//            let  cell = tableView.dequeueReusableCellWithIdentifier("addCell") as DynamicAddCell
//            cell.talkTitle.text = self.getData["dataObject","dynamic",indexPath.row,"talkTitle"].string
//            cell.forumName.text = self.getData["dataObject","dynamic",indexPath.row,"forumName"].string
//            var timeTemp = self.getData["dataObject","dynamic",indexPath.row,"insertTime"].string
//            cell.insertTime.text = GTUtil.compDate(timeTemp!)
//            cell.replyNum.text = String(self.getData["dataObject","dynamic",indexPath.row,"replyNum"].int!)
//            return cell
//        } else {
//            let  cell = tableView.dequeueReusableCellWithIdentifier("replyCell") as DynamicReplyCell
//            
//            cell.replyName.text = self.getData["dataObject","dynamic",indexPath.row,"operUserName"].string
//            cell.replyContent.text = self.getData["dataObject","dynamic",indexPath.row,"cont"].string
//            cell.talkTitle.text = self.getData["dataObject","dynamic",indexPath.row,"talkTitle"].string
//            cell.forumName.text = self.getData["dataObject","dynamic",indexPath.row,"forumName"].string
//            
//            var timeTemp = self.getData["dataObject","dynamic",indexPath.row,"insertTime"].string
//            cell.insertTime.text = GTUtil.compDate(timeTemp!)
//            cell.replyNum.text = String(self.getData["dataObject","dynamic",indexPath.row,"replyNum"].int!)
//            
//            return cell
//        }
//        
//        
//        
//    }
//     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var getType = self.getData["dataObject","dynamic",indexPath.row,"type"].string
//        if(getType == "talk_add"){
//            return 75
//        }else{
//            return 110
//        }
//    }
//    
//    //点击事件
//     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var tiezi = self.getData["dataObject","dynamic",indexPath.row,"cont1"].string!
//        println(tiezi)
//        TieziController.loadTiezi(presentNavigator: self.navigationController,id: tiezi)
//    }

    
    class func openOtherCenter(presentNavigator ctl:UINavigationController?,id:Int){
        var otherCenter = UIStoryboard(name: "OtherCenter", bundle: nil).instantiateViewControllerWithIdentifier("otherCenter") as OtherCenter
        otherCenter.userId = id
        if (ctl != nil) {
            ctl?.pushViewController(otherCenter, animated: true)
        } else {
            ctl?.presentViewController(otherCenter, animated: true, completion: nil)
        }

    }
    
    
    
}