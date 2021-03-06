//
//  dynamic.swift
//  mckuai
//
//  Created by 陈强 on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class Dynamic: UITableViewController, UIScrollViewDelegate {
    
    //该导航需要设置的
    var NavigationController:UINavigationController!
    
    @IBOutlet var tv: UITableView!
    var userInfo:UserCenter!
    var otherUser:OtherCenter!
    var userId = appUserIdSave
    
    var json = JSON("")
    var http_url = UserCenterUrl;
    var datasource: Array<JSON>!
    
    var currentPage = 1
    var itemCount = 0
    var pageSize = 0
    
    //上拉加载更多
    var LoadMoreText = UILabel()
    let tableFooterView = UIView()
    var normalTipe:String = "上拉查看更多"
    var CBSH_Refresh = CBStoreHouseRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None;
        //下拉刷新
        self.CBSH_Refresh = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "onRefresh", plist: "storehouse", color: UIColor.blackColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.5)
        initData()
        createTableFooter()
        self.tableView.tableFooterView?.hidden = true
    }
    
    //初始化tv的footerview
    func createTableFooter() {
        self.tableView.tableFooterView = nil
        tableFooterView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40)
        //println(UIScreen.mainScreen().bounds.size.width)
        //不知道为什么，这里取控件的宽度有问题
        LoadMoreText.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40)
        LoadMoreText.text = self.normalTipe
        LoadMoreText.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1.00)
        LoadMoreText.textAlignment = .Center
        tableFooterView.addSubview(LoadMoreText)
        self.tableView.tableFooterView = tableFooterView
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //开始上拉到特定位置后改变列表底部的提示
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+30) {
            LoadMoreText.text = "松开载入更多"
        } else {
            LoadMoreText.text = self.normalTipe
        }
        self.CBSH_Refresh.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.CBSH_Refresh.scrollViewDidEndDragging()
        LoadMoreText.text = self.normalTipe
        //上拉到一定程度后松开就开始加载更多
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 30) {
            onLoadMore()
        }
    }
    
    var dynamicNoData:UIViewController!=nil
    
    func initData() {
        //self.refreshing = true
        if GTUtil.CheckNetBreak() {
            return
        }
        
        var paramDictionary :Dictionary<String,String> = ["act":"dynamic","id":String(userId),"page":String(currentPage)]
        Alamofire.request(.GET,http_url, parameters: paramDictionary)
            .responseJSON { (request, response, data, error) in
                if data == nil {
                    if(self.currentPage==1){
                        self.showDefaultView()
                    }
                } else {
                    var jsonParse = data as NSDictionary
                    self.json = JSON(jsonParse)
                    
                    if(self.userInfo != nil){
                        self.userInfo.json = self.json
                        self.userInfo.setUserInfo()
                    }
                    
                    if(self.otherUser != nil){
                        self.otherUser.getData = self.json
                        self.otherUser.setUserInfo()
                    }
                    
                    
                    
                    var count = self.json["dataObject","dynamic"].count
                    self.itemCount = self.json["dataObject","pageInfo","allCount"].intValue
                    self.currentPage = self.json["dataObject","pageInfo","page"].intValue
                    if(count == 0) {
                        if(self.currentPage==1) {
                            self.showDefaultView()
                        }else{
                            self.normalTipe = "没有更多的动态消息"
                            self.LoadMoreText.text = self.normalTipe
                        }
                        
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
                        
                        if(self.datasource.count>=10){
                            self.tableView.tableFooterView?.hidden = false
                        }
                    }
  
                }
                self.CBSH_Refresh.finishingLoading()
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].stringValue
            if(getType == "talk_add") {
                let  cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as DynamicAddCell
                if !self.datasource.isEmpty {
                    var data = self.datasource[indexPath.row] as JSON
                    cell.update(data)
                }
                return cell
            } else {
                let  cell = self.tableView.dequeueReusableCellWithIdentifier("replyCell") as DynamicReplyCell
                if !self.datasource.isEmpty {
                    var data = self.datasource[indexPath.row] as JSON
                    cell.update(data)
                }
                return cell
            }

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var getType = self.json["dataObject","dynamic",indexPath.row,"type"].stringValue
        if(self.datasource.count == indexPath.row){
            return 30
        }else{
            if(getType == "talk_add"){
                return 70
            }else{
                return 108
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
        self.normalTipe = "上拉查看更多"
        if self.datasource != nil {
            self.datasource.removeAll()
        }
        
        self.initData()
    }
    
    func onLoadMore() {
        var nextPage = self.currentPage+1
        if ((nextPage*self.pageSize) - self.itemCount >= self.pageSize) {
//            UIAlertView(title: "提示", message: "已到最后一页", delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            self.currentPage = nextPage
        }
        self.initData()
    }
}