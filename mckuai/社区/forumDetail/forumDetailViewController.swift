//
//  forumDetailViewController.swift
//  test
//
//  Created by XingfuQiu on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class forumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var dese: UILabel!
    @IBOutlet weak var talkNum: UIButton!
    @IBOutlet weak var tv: UITableView!
    
    var datasource: Array<JSON>!
    var forum_ID = "1"
    var currentPage = 1
    var itemCount = 0
    var pageSize = 0
    var PostView: PostViewController!=nil
    var CBSH_Refresh = CBStoreHouseRefreshControl()
    
    //上拉加载更多
    var LoadMoreText = UILabel()
    let tableFooterView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.caption.text = "正在获取数据..."
        self.dese.text = ""
        self.talkNum.setTitle("", forState: .Normal)
        //下拉刷新
        self.CBSH_Refresh = CBStoreHouseRefreshControl.attachToScrollView(self.tv, target: self, refreshAction: "onRefresh", plist: "storehouse", color: UIColor.blackColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: true, internalAnimationFactor: 0.5)
        
        //加载数据进度
        sendRequest()

        // Do any additional setup after loading the view.
        self.tv.separatorStyle = .None
        self.tv.layoutIfNeeded()
    }

    
    //初始化tv的footerview
    func createTableFooter() {
        self.tv.tableFooterView = nil
        tableFooterView.frame = CGRectMake(0, 0, self.tv.bounds.size.width, 40)
        //println(UIScreen.mainScreen().bounds.size.width)
        //不知道为什么，这里取控件的宽度有问题
        LoadMoreText.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40)
        LoadMoreText.text = "上拉查看更多"
        LoadMoreText.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1.00)
        LoadMoreText.textAlignment = .Center
        tableFooterView.addSubview(LoadMoreText)
        self.tv.tableFooterView = tableFooterView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.CBSH_Refresh.scrollViewDidScroll()
        
        //开始上拉到特定位置后改变列表底部的提示
        if self.datasource != nil {
        if (self.itemCount != self.datasource.count) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+30) {
            LoadMoreText.text = "松开载入更多"
        } else {
            LoadMoreText.text = "上拉查看更多"
        }
        }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.CBSH_Refresh.scrollViewDidEndDragging()
        
        if self.datasource != nil {
        if (self.itemCount != self.datasource.count) {
        LoadMoreText.text = "上拉查看更多"
        //上拉到一定程度后松开就开始加载更多
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 30) {
            onLoadMore()
        }
        }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPost() {
        if(appUserIdSave != nil && appUserIdSave != 0){
            PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
            self.navigationController?.pushViewController(PostView, animated: true)
        } else {
            UserLogin.showUserLoginView(presentNavigator: self.navigationController)
        }
    }
    
    func sendRequest() {
        println("正在加载第\(self.forum_ID)的第：\(self.currentPage)页")
        var isShowHud = self.datasource == nil
        APIClient.sharedInstance.getCommunityBankuaiData(isShowHud, view:self.view, forumID: self.forum_ID, page: "\(self.currentPage)", success: { (json) -> Void in
            if json["state"].stringValue == "ok" {
                if let data = json["dataObject", "talkList"].array {
                    if self.datasource == nil {
                        self.datasource = data
                    } else {
                        self.datasource = self.datasource + data
                    }
                    println("self.datasource:\(self.datasource.count)")
                    self.tv.reloadData()
                }
                //分页信息
                var pageinfo = json["dataObject", "pageInfo"] as JSON
                self.itemCount = pageinfo["allCount"].intValue
                self.pageSize = pageinfo["pageSize"].intValue
                self.currentPage = pageinfo["page"].intValue
                //顶部信息
                self.setHead(json["dataObject", "forum"] as JSON)
                
                self.CBSH_Refresh.finishingLoading()
                
                if self.datasource != nil {
                    if self.itemCount != self.datasource.count {
                        self.createTableFooter()
                    }
                }
            }
            }, failure: { (error) -> Void in
                self.CBSH_Refresh.finishingLoading()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("forumCell") as forumDetailCell
        if !self.datasource.isEmpty {
            var data = self.datasource[indexPath.row] as JSON
            cell.update(data)
        }
        
        var cellheight = 64
        var bdb = UIView()
        var size = CGSize(width: self.tv.frame.size.width - 10, height: 1.0)
        var org = CGPoint(x: 5, y: cellheight-1)
        bdb.frame = CGRect(origin: org, size: size)
        bdb.backgroundColor = UIColor(white: 239/255, alpha: 1)
        cell.addSubview(bdb)
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.datasource.count == indexPath.row) {
            onLoadMore()
        } else {
            let data = self.datasource[indexPath.row] as JSON
            let tiezi = data["id"].stringValue
            TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
        }
    }
    
    func onRefresh() {
        self.currentPage = 1
        if self.datasource != nil {
            self.datasource.removeAll()
        }
        self.sendRequest()
    }

    func onLoadMore() {
        var nextPage = self.currentPage+1
        if ((nextPage*self.pageSize) - self.itemCount >= self.pageSize) {
            UIAlertView(title: "提示", message: "已到最后一页", delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            self.currentPage = nextPage
        }
        self.sendRequest()
    }
    
    func setHead(forum: JSON) {
        self.caption.text = forum["name"].stringValue
        self.dese.text = forum["shortDres"].stringValue
        self.talkNum.setTitle(forum["talkNum"].stringValue, forState: .Normal)
        var url = forum["icon"].stringValue
        //url = "http://pic.youxigt.com/uploadimg/quan/images1/68831411547537743.jpg"
        GTUtil.loadImageView(img: self.imageView, url: url)
    }

}
