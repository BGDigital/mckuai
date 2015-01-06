//
//  dynamic.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class Dynamic: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    //该导航需要设置的
    var NavigationController:UINavigationController!
    
//    @IBOutlet var tv: UITableView!
    
    var userId = appUserIdSave
    
    var json = JSON("")
    var http_url = UserCenterUrl;
    var datasource: Array<JSON>!
    
    var currentPage = 1
    var itemCount = 0
    var pageSize = 0
    
    var refreshView = UIRefreshControl()
    var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshView.beginRefreshing()
                self.refreshView.attributedTitle = NSAttributedString(string: "正在刷新...")
            }
            else {
                self.refreshView.endRefreshing()
                self.refreshView.attributedTitle = NSAttributedString(string: "正在刷新...")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        //下拉刷新
        refreshView.attributedTitle = NSAttributedString(string: "松开刷新列表")
        refreshView.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshView)
        initData()
    }
    var dynamicNoData:UIViewController!=nil
    
    func initData() {
        self.refreshing = true
        var paramDictionary :Dictionary<String,String> = ["act":"dynamic","id":String(userId),"page":String(currentPage)]
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    println("取不到数据，不显示")
                    self.showDefaultView()
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    var count = self.json["dataObject","dynamic"].count
                    self.itemCount = self.json["dataObject","pageInfo","allCount"].intValue
                    self.currentPage = self.json["dataObject","pageInfo","page"].intValue
                    if(count == 0) {
                        self.showDefaultView()
                    } else {
                        
                        if let dataList = self.json["dataObject", "dynamic"].array {
                            if self.datasource == nil {
                                self.datasource = dataList
                            } else {
                                self.datasource = self.datasource + dataList
                            }
                            
                            println("self.datasource:\(self.datasource.count)")
                            self.tableView.reloadData()
                        }
                        
//                        self.tableView.reloadData()
                    }
                    
                    self.refreshing = false
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
//        let j = self.json["dataObject","dynamic"] as JSON
//        if (j != nil) {
//            return j.count + 1
//        }
//        return 0
        
        if (self.datasource != nil) {
            return self.datasource.count + 1
        }
        return 0
        //return self.json["dataObject","dynamic"].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].string
        
        //处理加载更多
        if (self.datasource.count == indexPath.row) {
            var loadMoreCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            loadMoreCell.textLabel?.text = "加载更多..."
            //loadMoreCell.backgroundColor = UIColor(red: 0.812, green: 0.192, blue: 0.145, alpha: 1.00)
            loadMoreCell.textLabel?.textAlignment = NSTextAlignment.Center
            //最后一页，不显示加载更多
            loadMoreCell.hidden = (self.itemCount <= self.datasource.count)
            return loadMoreCell
        }else{
            if(getType == "talk_add") {
                let  cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as DynamicAddCell

                var data = self.datasource[indexPath.row] as JSON
                cell.update(data)
                return cell
            } else {
                let  cell = self.tableView.dequeueReusableCellWithIdentifier("replyCell") as DynamicReplyCell
                var data = self.datasource[indexPath.row] as JSON
                cell.update(data)
                return cell
            }

            
        }
        
        
        

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].string
        if(self.datasource.count == indexPath.row){
            return 30
        }else{
            if(getType == "talk_add"){
                return 75
            }else{
                return 110
            }
        }
        
    }
    
    //点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            if (self.datasource.count == indexPath.row) {
                onLoadMore()
            }else{
                
                let data = self.datasource[indexPath.row] as JSON
                let tiezi = data["cont1"].stringValue
//                var tiezi = self.json["dataObject","dynamic",indexPath.row,"cont1"].string!
                println(tiezi)
                TieziController.loadTiezi(presentNavigator: self.NavigationController,id: tiezi)
            }
        
    }
    
    func onRefresh() {
        self.currentPage = 1
        self.datasource.removeAll()
        self.initData()
    }
    
    func onLoadMore() {
        var nextPage = self.currentPage+1
        if ((nextPage*self.pageSize) - self.itemCount >= self.pageSize) {
            UIAlertView(title: "提示", message: "已到最后一页", delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            self.currentPage = nextPage
        }
        self.initData()
    }
}