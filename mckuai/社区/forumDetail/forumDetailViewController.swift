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
    
    
    var datasource: Array<JSON>! = Array<JSON>()
    var forum_ID = "1"
    var currentPage = 1
    var itemCount = 0
    var pageSize = 0
    var PostView: PostViewController!=nil
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        sendRequest()

        //下拉刷新
        refreshControl.attributedTitle = NSAttributedString(string: "松开刷新列表")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tv.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPost() {
        PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
        self.navigationController?.pushViewController(PostView, animated: true)
    }
    
    func sendRequest() {
        println("正在加载第\(self.forum_ID)的第：\(self.currentPage)页")
        self.refreshControl.beginRefreshing()
        APIClient.sharedInstance.getCommunityBankuaiData(self.forum_ID, page: "\(self.currentPage)", success: { (json) -> Void in

            if json["state"].stringValue == "ok" {
                
                if json["dataObject", "talkList"].type == Type.Array {
                    self.datasource = json["dataObject", "talkList"].arrayValue
                    //self.datasource[1...1] = json["dataObject", "talkList"].arrayValue
                    println(self.datasource.count)
                    self.tv.reloadData()
                }
                //分页信息
                var pageinfo = json["dataObject", "pageInfo"] as JSON
                self.itemCount = pageinfo["allCount"].intValue
                self.pageSize = pageinfo["pageSize"].intValue
                self.currentPage = pageinfo["page"].intValue
                //顶部信息
                self.setHead(json["dataObject", "forum"] as JSON)
                
                self.refreshControl.endRefreshing()
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
            loadMoreCell.textLabel?.text = "加载更多..."
            //loadMoreCell.backgroundColor = UIColor(red: 0.812, green: 0.192, blue: 0.145, alpha: 1.00)
            loadMoreCell.textLabel?.textAlignment = NSTextAlignment.Center
            //最后一页，不显示加载更多
            if self.datasource.count != 10 {
                loadMoreCell.hidden = true
            }
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
