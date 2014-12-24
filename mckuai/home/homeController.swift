//
//  homeController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class homeController: UIViewController, DHCarouselViewDelegate,UICollectionViewDataSource {
    
    var carouselView: DHCarouselView!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var topUserhead: UIImageView!
    
    @IBOutlet weak var topUsername: UILabel!
    
    @IBOutlet weak var topUserCountReply: UILabel!
    
    @IBOutlet weak var topUserCountTiezi: UILabel!
    
    @IBOutlet weak var famouseUserCView: UICollectionView!
    
    @IBOutlet weak var shenFen:UIImageView!

    
    
    var data:JSON!{
        didSet{
            if(data["user"].type ==  Type.Array){
                famouseUsers = data["user"].arrayValue
            }
            if(data["banner"].type == Type.Array){
                bannerImages = data["banner"].arrayValue
            }
        }
    }
    
    var famouseUsers:Array<JSON>!{
        didSet{
            topOneUser =  famouseUsers[0]
            famouseUserCView.reloadData()
        }
    }
    
    var topOneUser:JSON!{
        didSet{
            topUsername.text = topOneUser["nike"].stringValue
            topUserCountReply.text = topOneUser["talkNum"].stringValue
            topUserCountTiezi.text = topOneUser["homeNum"].stringValue
            var src = topOneUser["headImg"].stringValue
            GTUtil.loadImageView(img: topUserhead,url: src)
            if topOneUser["isServerActor"].stringValue == "1"{
                shenFen.image = UIImage(named: "icon_fu")
            }
        }
    }
    
    var bannerImages:Array<JSON>!{
        didSet{
            var imgUrls = bannerImages.map({(var json) -> String in
                return json["imgUrl"].stringValue                
            })
            carouselView.carouselDataArray = imgUrls
            carouselView.loadCarouselDataThenStart()
            self.view.addSubview(carouselView)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initData()
     
        famouseUserCView.dataSource = self
        
        InitCarouselView(125)
        
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func InitCarouselView(high: CGFloat) {
        carouselView = DHCarouselView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.size.width, height: high)))
        carouselView.delegate = self
        carouselView.carouselPeriodTime = 4.0
//        carouselView.carouselDataArray = [
//            "http://cdn.mckuai.com/banner/20141209/201412091444140687.jpg",
//            "http://cdn.mckuai.com/banner/20141209/201412091102260156.jpg",
//            "http://cdn.mckuai.com/banner/20141205/201412051824380984.jpg",
//            "http://cdn.mckuai.com/banner/20141209/201412091102260156.jpg",
//            "http://cdn.mckuai.com/banner/20141209/201412091104130875.jpg"
//        ]
//        
//        carouselView.loadCarouselDataThenStart()
//        self.view.addSubview(carouselView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.scrollView != nil){//iPhone的滚动
            //var size = desc.text.textSizeWithFont(desc.font, constrainedToSize: CGSize(width:306, height:1000))
            scrollView.contentSize = CGSize(width: 320, height: 600)
            self.view.layoutIfNeeded()
        }
    }
    
    func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger) {
        var banner = bannerImages[index]
        
        TieziController.loadTiezi(presentNavigator: self.navigationController!, id: banner["id"].stringValue)
    }
    
    
    //初始化数据
    func initData(){
        APIClient.sharedInstance.getHomePageData({
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
            }
        )
    }
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int{
//            println("明星用户")
            if(famouseUsers != nil){
                return famouseUsers.count-1
            }
            else{
                return 0
            }
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("famouse",forIndexPath:indexPath) as FamouseUser
//                        println("here")
            let user = famouseUsers[indexPath.row+1]
            
            GTUtil.loadImageView(img: cell.userhead,url: user["headImg"].stringValue)
            return cell
    }
    
}

class FamouseUser:UICollectionViewCell {
    
    @IBOutlet weak var userhead: UIImageView!
    
}