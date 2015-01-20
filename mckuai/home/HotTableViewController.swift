//
//  HotTableView.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/10.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//


import UIKit

class HotTableViewController:UITableViewController {
    
    
    
    var data:JSON!{
        didSet{
//            println("data setted")
            if (data["talk"].type == Type.Array) {
                self.hotTiezi = data["talk"].arrayValue
            }
        }
    }
    var hotTiezi:Array<JSON>!{
        didSet{
//            println("table setted")
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        分隔线
//        self.tableView.separatorStyle = .None
        self.tableView.scrollEnabled = false
        APIClient.sharedInstance.getHomePageData(self.view, {
            (json) -> Void in
             if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveHomePageData(json.object)
                self.data = json["dataObject"]
             }
            }, {
                (err) -> Void in
                if let d = AppContext.sharedInstance.getHomePageData(){
                    self.data = d["dataObject"]
                }
            }
        )
        
    }
    
    override func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("hottiezi",forIndexPath:indexPath) as HotTableViewCell;
        
        cell.update(hotTiezi[indexPath.row])
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("热门帖子数量")
        if(hotTiezi != nil){
            return hotTiezi.count
        }else{
//            println("nil")
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tiezi = hotTiezi[indexPath.row]["id"].stringValue
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
    }
    
    
}