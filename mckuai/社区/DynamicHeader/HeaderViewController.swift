//
//  HeaderViewController.swift
//  test
//
//  Created by XingfuQiu on 14/11/27.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//


import UIKit

class HeaderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var headCaption: UILabel!
    @IBOutlet weak var headTime: UILabel!
    @IBOutlet weak var headReplyNum: UILabel!
    var datasource: Array<JSON>!
    var huodong: JSON!
    var forumDetailc: forumDetailViewController!=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //是否读取缓存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var nodes = AppContext.sharedInstance.getCommunityData()
            dispatch_async(dispatch_get_main_queue(), {
                if let json = nodes? {
                    self.datasource = json["dataObject", "forum"].arrayValue
                    self.cv.reloadData()
                    self.huodong = json["dataObject", "huodong", 0] as JSON
                    
                    if (self.huodong != nil) {
                        self.headCaption.text = self.huodong["talkTitle"].stringValue
                        self.headTime.text = self.huodong["endTime"].stringValue
                        self.headReplyNum.text = self.huodong["replyNum"].stringValue
                    }
                } else {
                    self.sendRequest()
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //获取数据
    func sendRequest() {
        APIClient.sharedInstance.getCommunityData({ (json) -> Void in

            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveCommunityData(json.object)
                if (json["dataObject", "forum"].type == Type.Array) {
                    self.datasource = json["dataObject", "forum"].arrayValue
                    self.cv.reloadData()
                    self.huodong = json["dataObject", "huodong", 0] as JSON
                    
                    self.headCaption.text = self.huodong["talkTitle"].stringValue
                    self.headTime.text = self.huodong["endTime"].stringValue
                    self.headReplyNum.text = self.huodong["replyNum"].stringValue
                }
            }
            }) { (error) -> Void in
                //
        }

    }
    
    //显示活动页面
    @IBAction func showhuodong() {
        let tiezi = self.huodong["id"].stringValue
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = cv.dequeueReusableCellWithReuseIdentifier("Cella", forIndexPath: indexPath) as CollectionViewCell
        var data = self.datasource[indexPath.row] as JSON
        cell.update(data)

        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        forumDetailc = UIStoryboard(name: "forumDetail", bundle: nil).instantiateViewControllerWithIdentifier("SB_forumDetail") as forumDetailViewController
        var data = self.datasource[indexPath.row] as JSON
        var forumid = data["id"].stringValue
        forumDetailc.forum_ID = forumid
        self.navigationController?.pushViewController(forumDetailc, animated: true)
        return true
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
