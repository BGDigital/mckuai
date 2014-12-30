//
//  dynamic.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire
class Dynamic: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    //该导航需要设置的
    var NavigationController:UINavigationController!
    
    var userId = appUserIdSave
    
    var json = JSON("")
    var http_url = UserCenterUrl;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        initData()
    }
    var dynamicNoData:UIViewController!=nil
    func initData() {
        var paramDictionary :Dictionary<String,String> = ["act":"dynamic","id":String(userId)]
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    println("取不到数据，不显示")
                    //self.tableView.hidden = true
                    self.showDefaultView()
                    
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    var count = self.json["dataObject","dynamic"].count
                    println("count\(count)")
                    println(self.json["state"])
                    if(count == 0) {
                        self.showDefaultView()
                    } else {
                        self.tableView.reloadData()
                    }
                }
        }

    }
    
    func showDefaultView() {
        self.dynamicNoData = UIStoryboard(name: "dynamicNoData", bundle: nil).instantiateViewControllerWithIdentifier("noDataSb")as UIViewController
        self.dynamicNoData.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.dynamicNoData.view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let j = self.json["dataObject","dynamic"] as JSON
        if (j != nil) {
            return j.count
        }
        return 0
        //return self.json["dataObject","dynamic"].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].string
        if(getType == "talk_add") {
           let  cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as DynamicAddCell
           cell.talkTitle.text = self.json["dataObject","dynamic",indexPath.row,"talkTitle"].string
           cell.forumName.text = self.json["dataObject","dynamic",indexPath.row,"forumName"].string
           var timeTemp = self.json["dataObject","dynamic",indexPath.row,"insertTime"].string
           cell.insertTime.text = GTUtil.compDate(timeTemp!)
           cell.replyNum.text = String(self.json["dataObject","dynamic",indexPath.row,"replyNum"].int!)
           return cell
        } else {
           let  cell = self.tableView.dequeueReusableCellWithIdentifier("replyCell") as DynamicReplyCell
            
            cell.replyName.text = self.json["dataObject","dynamic",indexPath.row,"operUserName"].string
            cell.replyContent.text = self.json["dataObject","dynamic",indexPath.row,"cont"].string
            cell.talkTitle.text = self.json["dataObject","dynamic",indexPath.row,"talkTitle"].string
            cell.forumName.text = self.json["dataObject","dynamic",indexPath.row,"forumName"].string
            
            var timeTemp = self.json["dataObject","dynamic",indexPath.row,"insertTime"].string
            cell.insertTime.text = GTUtil.compDate(timeTemp!)
            cell.replyNum.text = String(self.json["dataObject","dynamic",indexPath.row,"replyNum"].int!)
            
           return cell
        }
        
        

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].string
        if(getType == "talk_add"){
            return 75
        }else{
            return 110
        }
    }
    
    //点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var tiezi = self.json["dataObject","dynamic",indexPath.row,"cont1"].string!
            println(tiezi)
            TieziController.loadTiezi(presentNavigator: self.NavigationController,id: tiezi)
    }
    
    func reloadData(){
        println("重新加载数据")
        self.tableView.reloadData()
    }
}