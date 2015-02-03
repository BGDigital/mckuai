//
//  HotTableView.swift
//  mckuai
//
//  Created by 夕阳 on 14/12/10.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//


import UIKit

class HotTableViewController:UITableViewController, DHCarouselViewDelegate, UIScrollViewDelegate {
    
    var CBSH_Refresh = CBStoreHouseRefreshControl()
    var carouselView: DHCarouselView!
    let fpic: CGFloat = 0.5
    var picHeight: CGFloat!
    var data:JSON!{
        didSet{
//            println("data setted")
            if (data["talk"].type == Type.Array) {
                self.hotTiezi = data["talk"].arrayValue
            }
            if(data["banner"].type == Type.Array){
                bannerImages = data["banner"].arrayValue
            }
        }
    }
    var hotTiezi:Array<JSON>!{
        didSet{
//            println("table setted")
            self.tableView.reloadData()
        }
    }
    var bannerImages:Array<JSON>!{
        didSet{
            var imgUrls = bannerImages.map({(var json) -> String in
                return json["imgUrl"].stringValue
            })
            var titles = bannerImages.map({(var json) -> String in
                return json["title"].stringValue
            })
            carouselView.carouselDataArray = imgUrls
            carouselView.carouseTitle = titles
            carouselView.emptyCarouseView()
            carouselView.loadCarouselDataThenStart()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .None
        self.tableView.layoutIfNeeded()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        InitData(true)
        picHeight = (self.view.frame.size.width * fpic)
        InitCarouselView(picHeight)
        self.CBSH_Refresh = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "onPullToFresh", plist: "storehouse", color: UIColor.blackColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: true, internalAnimationFactor: 0.5)
        
    }
    
    func InitCarouselView(high: CGFloat) {
        carouselView = DHCarouselView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.size.width, height: high)))
        carouselView.delegate = self
        carouselView.carouselPeriodTime = 4.0
        
        //self.view.addSubview(carouselView)
        self.tableView.tableHeaderView = carouselView
    }
    
    //banner 图的点击事件
    func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger) {
        var banner = bannerImages[index]
        
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: banner["id"].stringValue)
    }
    
    func InitData(isShowHud: Bool) {
        APIClient.sharedInstance.getHomePageData(isShowHud, view:self.view, {
            (json) -> Void in
            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveHomePageData(json.object)
                self.data = json["dataObject"]
                self.CBSH_Refresh.finishingLoading()
            }
            }, {
                (err) -> Void in
                
                if let d = AppContext.sharedInstance.getHomePageData(){
                    self.data = d["dataObject"]
                    if self.data == nil {
                        self.showDefaultView()
                    }
                    self.CBSH_Refresh.finishingLoading()
                }
            }
        )
    }
    
    func onPullToFresh() {
        InitData(false)
    }
    
    override func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("hottiezi",forIndexPath:indexPath) as HotTableViewCell;
        
        //画分割线
        var cellheight = 72
        var bdb = UIView()
        var size = CGSize(width: tableView.frame.size.width - 10, height: 1.0)
        var org = CGPoint(x: 5, y: cellheight-1)
        bdb.frame = CGRect(origin: org, size: size)
        bdb.backgroundColor = UIColor(white: 239/255, alpha: 1)
        cell.addSubview(bdb)
        
        cell.update(hotTiezi[indexPath.row])
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("热门帖子数量")
        if(hotTiezi != nil){
            return hotTiezi.count
        }else{
//            println("nil")
            return 0
        }
    }
    
    var dynamicNoData:UIViewController!=nil
    func showDefaultView(){
        self.dynamicNoData = UIStoryboard(name: "dynamicNoData", bundle: nil).instantiateViewControllerWithIdentifier("noDataSb")as UIViewController
        self.dynamicNoData.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.dynamicNoData.view)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tiezi = hotTiezi[indexPath.row]["id"].stringValue
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.CBSH_Refresh.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.CBSH_Refresh.scrollViewDidEndDragging()
    }
    
}