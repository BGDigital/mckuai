//
//  homeController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class homeController: UIViewController, DHCarouselViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var carouselView: DHCarouselView!

    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet weak var famouseUserCView: UICollectionView!
    
    
    var data:JSON!{
        didSet{
            if(data["user"].type ==  Type.Array){
                famouseUsers = data["user"].arrayValue
            }
            if(data["banner"].type == Type.Array){
                bannerImages = data["banner"].arrayValue
            }
            if (data["talk"].type == Type.Array) {
                self.hotTiezi = data["talk"].arrayValue
            }
        }
    }
    
    var famouseUsers:Array<JSON>!{
        didSet{
            famouseUserCView.reloadData()
        }
    }
    var hotTiezi:Array<JSON>!{
        didSet{
            hotTieziView.reloadData()
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
    
    
    @IBOutlet weak var hotTieziView: UITableView!
    
    var pull = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
     
        famouseUserCView.dataSource = self
        famouseUserCView.delegate = self
        famouseUserCView.scrollEnabled = false
        InitCarouselView(125)
        
        hotTieziView.scrollEnabled = false
        hotTieziView.delegate = self
        hotTieziView.dataSource = self
        
        //scroll view 本身
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 100)
        
        pull.attributedTitle = NSAttributedString(string: "再拉就刷新了哦^_^")
        pull.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
        pull.tintColor = UIColor(white: 0.95, alpha: 1)

        self.scrollView.addSubview(pull)
    }
    
    func onPullToFresh(){
        pull.beginRefreshing()
        initData();
        pull.endRefreshing()
    }
    
    func InitCarouselView(high: CGFloat) {
        carouselView = DHCarouselView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.size.width, height: high)))
        carouselView.delegate = self
        carouselView.carouselPeriodTime = 4.0
        
        self.view.addSubview(carouselView)
    }
    
    override func viewDidAppear(animated: Bool) {
//        println("home appear")
        hotTieziView.scrollEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.scrollView != nil){//
            scrollView.contentSize = CGSize(width: 320, height: 650)
            self.view.layoutIfNeeded()
        }
    }
    
    //banner 图的点击事件
    func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger) {
        var banner = bannerImages[index]
        
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: banner["id"].stringValue)
    }
    
    
    //初始化数据
    func initData(){
        println("尝试加载数据")
//        //判断网络是已连接
//        if !Reachability.isConnectedToNetwork() {
//            SweetAlert().showAlert("出错啦", subTitle: "检查一下流量开关或连上WiFi再试试", style: AlertStyle.Warning, buttonTitle:"", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "知道了", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
//                if isOtherButton == true {
//                    
//                    println("Cancel Button  Pressed")
//                }
//                else {
////                    SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
//                }
//            }
//            return
//        }

        
        APIClient.sharedInstance.getHomePageData(self.view, {
            (json) -> Void in
            if "ok" == json["state"].stringValue {
                AppContext.sharedInstance.saveHomePageData(json.object)
                self.data = json["dataObject"]
//                println(json);
            }
            }, {
                (err) -> Void in
                if let d = AppContext.sharedInstance.getHomePageData(){
                    self.data = d["dataObject"]
                }
                else{
                    println("网络出错.\(err)")
                }
            }
        )
    }
    
    /*热门帖子的delegate*/
    
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
//        println("获取cell")
        var cell = tableView.dequeueReusableCellWithIdentifier("hottiezi",forIndexPath:indexPath) as HotTableViewCell;
        
        var index = indexPath.row%hotTiezi.count;
        
        cell.update(hotTiezi[index])
        
        if index < hotTiezi.count-1{
            var bdb = UIView()
            var size = CGSize(width: self.scrollView.frame.size.width - 18, height: 1.0)
            var org = CGPoint(x: 0, y: cell.frame.size.height-1)
            bdb.frame = CGRect(origin: org, size: size)
            bdb.backgroundColor = UIColor(white: 239/255, alpha: 1)
            cell.addSubview(bdb)
        }else{
            tableView.frame.size = CGSize(width: tableView.frame.size.width, height: cell.frame.height * 12.0)
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("热门帖子数量:")
        if(hotTiezi != nil){
//            println(hotTiezi.count)
            return hotTiezi.count*2
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tiezi = hotTiezi[indexPath.row]["id"].stringValue
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: tiezi)
    }
    
    
    
    /**
    热门明星的delegate
    */
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int{
//            println("明星用户")
            if(famouseUsers != nil){
                return famouseUsers.count
            }
            else{
                return 0
            }
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("famouse",forIndexPath:indexPath) as FamouseUser
            
            let user = famouseUsers[indexPath.row+1]
            
            GTUtil.loadImageView(img: cell.userhead,url: user["headImg"].stringValue)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        

        let user = famouseUsers[indexPath.row+1]
                println(user)
        OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: user["id"].intValue)
    }
    
}

class FamouseUser:UICollectionViewCell {
    
    @IBOutlet weak var userhead: UIImageView!
    
}