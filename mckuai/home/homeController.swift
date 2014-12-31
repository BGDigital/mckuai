//
//  homeController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class homeController: UIViewController, DHCarouselViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    
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
        famouseUserCView.delegate = self
        famouseUserCView.scrollEnabled = false
        InitCarouselView(125)
        
        //navigation bar 背景
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 100)

    }
    
    func InitCarouselView(high: CGFloat) {
        carouselView = DHCarouselView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.size.width, height: high)))
        carouselView.delegate = self
        carouselView.carouselPeriodTime = 4.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.scrollView != nil){//iPhone的滚动
            //var size = desc.text.textSizeWithFont(desc.font, constrainedToSize: CGSize(width:306, height:1000))
//            var rect = CGRect.zeroRect;
//            for v in scrollView.subviews {
//                rect = CGRectUnion(rect, v.frame)
//            }
            //ScrollView 合适的大小为:
            scrollView.contentSize = CGSize(width: 320, height: 725)
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
            
            let user = famouseUsers[indexPath.row+1]
            
            GTUtil.loadImageView(img: cell.userhead,url: user["headImg"].stringValue)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        

        let user = famouseUsers[indexPath.row+1]
                println(user)
        OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: user["id"].intValue)
    }
    
    @IBAction func toTopOneuser(){
        OtherCenter.openOtherCenter(presentNavigator: self.navigationController, id: topOneUser["id"].intValue)
    }
}

class FamouseUser:UICollectionViewCell {
    
    @IBOutlet weak var userhead: UIImageView!
    
}