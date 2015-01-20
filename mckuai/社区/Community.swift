//
//  Community.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class Community: BaseTableViewController {
    var json: JSON!
    var PostView: PostViewController!=nil
    var forumDetailc: forumDetailViewController!=nil
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        self.sendRequest()
    }
    
    @IBAction func showPost() {
        PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
        self.navigationController?.pushViewController(PostView, animated: true)
    }
    
    func sendRequest() {
        APIClient.sharedInstance.getCommunityData(self.view, { (json) -> Void in
            self.refreshing = false
            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveCommunityData(json.object)
                if (json["dataObject"].type == Type.Array) {
                    self.datasource = json["dataObject"].arrayValue
                }
            }
            }) { (error) -> Void in
                self.refreshing = false
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as? DynamicCell
        if !self.datasource.isEmpty {
            let d = self.datasource[indexPath.section] as JSON
            let data = d["list", indexPath.row] as JSON
            // Configure the cell...
            cell?.update(data)
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        forumDetailc = UIStoryboard(name: "forumDetail", bundle: nil).instantiateViewControllerWithIdentifier("SB_forumDetail") as forumDetailViewController
        
        let d = self.datasource[indexPath.section] as JSON
        let data = d["list", indexPath.row] as JSON
        var forumid = data["id"].stringValue
        forumDetailc.forum_ID = forumid
        self.navigationController?.pushViewController(forumDetailc, animated: true)
//        let data = self.datasource[indexPath.row] as JSON
//        let tiezi = data["id"].stringValue
//        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
    }

    
    func onPullToFresh() {
        self.sendRequest()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
