//
//  Community.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class Community: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var json = JSON("")
    var imageCache = Dictionary<String, UIImage>()
    override func viewDidLoad() {
        initData()
        super.viewDidLoad()
        //loadHeader()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func initData() {
        Alamofire.request(.GET, "http://221.237.152.39:8081/zone.do?act=all", parameters: nil)
            .responseJSON { (request, response, data, error) in
                
                if data == nil {
                    println("取不到数据，不显示")
                } else {
                var jsonParse = data as NSDictionary
                self.json = JSON(jsonParse)
                
                var count = self.json["dataObject","recTalk"].count
                println("count\(count)")
                println(self.json["state"])
                
                self.tableView.reloadData()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.json["dataObject","recTalk"].count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        //cell.textLabel.text = self.json["dataObject"]["recTalk"][indexPath.row]["talkTitle"].string
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as DynamicCell
        cell.title.text = self.json["dataObject","recTalk",indexPath.row,"talkTitle"].string
        cell.username.text = self.json["dataObject","recTalk",indexPath.row,"userName"].string
        cell.time.text = self.json["dataObject","recTalk",indexPath.row,"replyTime"].string
        cell.replyNum.text = self.json["dataObject","recTalk",indexPath.row,"replyNum"].string
        
        //这里UIImage的值判断有问题，所以就直接判断url地址是不是为空了
        //var url = self.json["dataObject"]["recTalk"][indexPath.row]["mobilePic"].string!
        var url = "http://pic.youxigt.com/uploadimg/quan/images1/68831411547537743.jpg"
        let image = self.imageCache[url]
        if (image == nil) {
            //println("缓存中没有图片，从网上获取")
            let imgURL: NSURL = NSURL(string:url)!
            let request:NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                var img=UIImage(data:data)
                cell.imgComm.image=img
                self.imageCache[url] = img })
        }
        else
        {
            //println("缓存中有图片，直接显示出来")
            cell.imgComm.image = image
        }

        // Configure the cell...

        return cell
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
