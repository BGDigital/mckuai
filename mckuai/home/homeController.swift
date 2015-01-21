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
    @IBOutlet weak var starView: UIView!
    
    
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
    let fpic: CGFloat = 0.36
    var picHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
     
        famouseUserCView.dataSource = self
        famouseUserCView.delegate = self
        famouseUserCView.scrollEnabled = false
        picHeight = (UIScreen.mainScreen().bounds.width * fpic)
        InitCarouselView(picHeight)
        
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
        self.scrollView.layoutSubviews()
        
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
        
        //self.view.addSubview(carouselView)
        self.hotTieziView.tableHeaderView = carouselView
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
            
            self.hotTieziView.frame.size.height = CGFloat(self.picHeight)+72*6+20
            self.starView.frame = CGRectMake(0, self.hotTieziView.frame.size.height, self.starView.frame.size.width, self.starView.frame.size.height)
            
            scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: self.hotTieziView.frame.size.height+self.starView.frame.size.height+3)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat  {
        return 20;
    }
    
    //自定义Section样式
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var v = UIView()
        v.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1.00)
        var label = UILabel(frame: CGRectMake(10, 0, 90, 20))
        label.textColor = UIColor(red: 0.439, green: 0.439, blue: 0.439, alpha: 1.00)
        label.text = "热贴推荐"
        label.font = UIFont(name: label.font.fontName, size: 13)
        v.addSubview(label)
        
        var img = UIImageView(frame: CGRect(x: UIScreen.mainScreen().bounds.size.width-20, y: 0, width: 20, height: 20))
        img.image = UIImage(named: "image1")
        v.addSubview(img)
        
        return v
    }
    
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
//        println("获取cell")
        var cell = tableView.dequeueReusableCellWithIdentifier("hottiezi",forIndexPath:indexPath) as HotTableViewCell;
        
        var index = indexPath.row%hotTiezi.count;
        
        cell.update(hotTiezi[index])
        
        if index < hotTiezi.count-1{
            var bdb = UIView()
            var size = CGSize(width: self.scrollView.frame.size.width-10, height: 1.0)
            var org = CGPoint(x: 5, y: cell.frame.size.height-1)
            bdb.frame = CGRect(origin: org, size: size)
            bdb.backgroundColor = UIColor(white: 239/255, alpha: 1)
            cell.addSubview(bdb)
        }else{
//            tableView.frame.size = CGSize(width: tableView.frame.size.width, height: cell.frame.height * CGFloat(hotTiezi.count)+CGFloat(self.picHeight))
//            
//            self.scrollView.layoutIfNeeded()
        }
        
        println(index)
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(hotTiezi != nil){
            return hotTiezi.count
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
            if !famouseUsers.isEmpty {
                let user = famouseUsers[indexPath.row]
            
                GTUtil.loadImageView(img: cell.userhead,url: user["headImg"].stringValue)
            }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !famouseUsers.isEmpty {
            let user = famouseUsers[indexPath.row]
                println(user)
            OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: user["id"].intValue)
        }
    }
    
}

class FamouseUser:UICollectionViewCell {
    
    @IBOutlet weak var userhead: UIImageView!
    
}