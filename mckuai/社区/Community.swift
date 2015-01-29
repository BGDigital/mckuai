//
//  Community.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class Community: BaseTableViewController {
    
    @IBOutlet var tv: UITableView!
    
    var json: JSON!
    var PostView: PostViewController!=nil
    var forumDetailc: forumDetailViewController!=nil
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tv.frame = CGRectMake(0, 0, self.tv.frame.size.width, self.tv.frame.size.height)
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        self.sendRequest()
        self.tv.separatorStyle = .None
        self.tv.layoutIfNeeded()
    }
    
    @IBAction func showPost() {
        PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
        self.navigationController?.pushViewController(PostView, animated: true)
    }
    
    func sendRequest() {
        var showHub = self.datasource == nil

        APIClient.sharedInstance.getCommunityData(showHub, view:self.view, { (json) -> Void in
            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveCommunityData(json.object)
                if (json["dataObject"].type == Type.Array) {
                    self.datasource = json["dataObject"].arrayValue
                    self.CBSH_Refresh.finishingLoading()
                }
            }
            }) { (error) -> Void in
                self.CBSH_Refresh.finishingLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat  {
        return 20;
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "section"
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            let d = self.datasource[section] as JSON
            return d["list"].count
        }
        return 0
        
    }
    //自定义Section样式
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var v = UIView()
        v.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1.00)
        var label = UILabel(frame: CGRectMake(10, 0, 90, 20))
        label.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1.00)
        let d = self.datasource[section] as JSON
        label.text = d["name"].stringValue
        label.font = UIFont(name: label.font.fontName, size: 13)
        v.addSubview(label)
        return v
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as DynamicCell
        if !self.datasource.isEmpty {
            let d = self.datasource[indexPath.section] as JSON
            let data = d["list", indexPath.row] as JSON
            // Configure the cell...
            //画分割线
                var cellheight = 60
                var bdb = UIView()
                var size = CGSize(width: self.tv.frame.size.width - 10, height: 1.0)
                var org = CGPoint(x: 5, y: cellheight-1)
                bdb.frame = CGRect(origin: org, size: size)
                bdb.backgroundColor = UIColor(white: 239/255, alpha: 1)
                cell.addSubview(bdb)

            cell.update(data)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        forumDetailc = UIStoryboard(name: "forumDetail", bundle: nil).instantiateViewControllerWithIdentifier("SB_forumDetail") as forumDetailViewController
        
        let d = self.datasource[indexPath.section] as JSON
        let data = d["list", indexPath.row] as JSON
        var forumid = data["id"].stringValue
        forumDetailc.forum_ID = forumid
        self.navigationController?.pushViewController(forumDetailc, animated: true)

    }

    func onPullToFresh() {
        self.tv.frame = CGRectMake(0, 0, self.tv.frame.size.width, self.tv.frame.size.height)
        self.sendRequest()
    }

}
