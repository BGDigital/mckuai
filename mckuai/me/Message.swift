//
//  message.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire

class Message: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    //该导航需要设置的
    var NavigationController:UINavigationController!
    var json = JSON("")
    var http_url = UserCenterUrl;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationController.navigationBar.hidden = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        initData()
    }
    
    var dynamicNoData:UIViewController!=nil
    func initData() {
        var paramDictionary :Dictionary<String,String> = ["act":"message","id":String(appUserIdSave)]
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    println("取不到数据，不显示")
                    //self.tableView.hidden = true
                    self.showDefaultView()
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    var count = self.json["dataObject","message"].count
                    println("count\(count)")
                    println(self.json["state"])
                    if(count == 0) {
                        self.showDefaultView()
                    }else {
                        self.tableView.reloadData()
                    }

                    
                }
        }
        
    }
    
    func showDefaultView(){
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
        
        return self.json["dataObject","message"].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let  cell = self.tableView.dequeueReusableCellWithIdentifier("messageCell") as MessageCell
        
            cell.userName.text = self.json["dataObject","message",indexPath.row,"userName"].string
            cell.content.text = self.json["dataObject","message",indexPath.row,"content"].string
            cell.talkTitle.text = self.json["dataObject","message",indexPath.row,"talkTitle"].string
        
            cell.forumName.text = self.json["dataObject","message",indexPath.row,"forumName"].string
            var timeTemp = self.json["dataObject","message",indexPath.row,"insertTime"].string
            cell.insertTime.text = GTUtil.compDate(timeTemp!)
//            cell.insertTime.text = self.json["dataObject","message",indexPath.row,"insertTime"].string
            cell.replyNum.text = String(self.json["dataObject","message",indexPath.row,"replyNum"].int!)
            cell.content.text = self.json["dataObject","message",indexPath.row,"cont"].string
            return cell

        
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 115
    }
    
    //点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tiezi = self.json["dataObject","message",indexPath.row,"cont1"].string!
        println(tiezi)
        TieziController.loadTiezi(presentNavigator: self.NavigationController, id: tiezi)
        
    }

}
