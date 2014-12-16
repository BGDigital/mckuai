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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var nodes = AppContext.sharedInstance.getCommunityData()
            dispatch_async(dispatch_get_main_queue(), {
                if let json = nodes? {
                    self.datasource = json["dataObject", "recTalk"].arrayValue
                } else {
                    self.sendRequest()
                }
            })
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func showPost() {
        PostView = UIStoryboard(name: "Post", bundle: nil).instantiateViewControllerWithIdentifier("SB_POST") as PostViewController
        self.navigationController?.pushViewController(PostView, animated: true)
    }
    
    func sendRequest() {
        self.refreshing = true
        APIClient.sharedInstance.getCommunityData({ (json) -> Void in
            self.refreshing = false
            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveCommunityData(json.object)
                if (json["dataObject", "recTalk"].type == Type.Array) {
                    self.datasource = json["dataObject", "recTalk"].arrayValue
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as? DynamicCell
        let data = self.datasource[indexPath.row] as JSON
        cell?.update(data)
        // Configure the cell...
        return cell!
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
