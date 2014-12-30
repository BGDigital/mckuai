//
//  forumDetailViewController.swift
//  test
//
//  Created by XingfuQiu on 14/12/3.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire

class forumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    var refreshControl = UIRefreshControl()
    
    var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshControl.beginRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "正在刷新...")
            }
            else {
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "正在刷新...")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.caption.text = "正在获取数据..."
        self.dese.text = "正在获取数据..."
        self.talkNum.setTitle("正在获取数据...", forState: .Normal)
        
        //下拉刷新
        refreshControl.attributedTitle = NSAttributedString(string: "松开刷新列表")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tv.addSubview(refreshControl)
        
        //加载数据进度
        sendRequest()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func loaddata() {
//        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
//        indicator.text = "正在加载数据..."
//        
//        dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
//            sleep(2)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                WIndicator.removeIndicatorFrom(self.view, animation: true)
//            })
//            
//        })
//    }
    
    @IBAction func showPost() {
        PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
        self.navigationController?.pushViewController(PostView, animated: true)
    }
    
    func sendRequest() {
        println("正在加载第\(self.forum_ID)的第：\(self.currentPage)页")
        self.refreshing = true
        APIClient.sharedInstance.getCommunityBankuaiData(self.forum_ID, page: "\(self.currentPage)", success: { (json) -> Void in

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
                
                self.refreshing = false
            }
            }, failure: { (error) -> Void in })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count+1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //处理加载更多
        if (self.datasource.count == indexPath.row) {
            var loadMoreCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            loadMoreCell.textLabel.text = "加载更多..."
            //loadMoreCell.backgroundColor = UIColor(red: 0.812, green: 0.192, blue: 0.145, alpha: 1.00)
            loadMoreCell.textLabel.textAlignment = NSTextAlignment.Center
            //最后一页，不显示加载更多
            loadMoreCell.hidden = (self.itemCount <= self.datasource.count)
            return loadMoreCell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("forumCell") as forumDetailCell
        var data = self.datasource[indexPath.row] as JSON
        cell.update(data)
        
        return cell
    }
    
    //动态设置Cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.datasource.count == indexPath.row) {
            return 30
        } else {
            return 64
        }
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
        self.datasource.removeAll()
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
