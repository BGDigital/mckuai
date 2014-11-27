//
//  homeController.swift
//  mckuai
//
//  Created by XingfuQiu on 14/11/12.
//  Copyright (c) 2014年 XingfuQiu. All rights reserved.
//

import UIKit

class homeController: UIViewController, DHCarouselViewDelegate {
    
    var carouselView: DHCarouselView!

    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitCarouselView(115)
        
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
        
        carouselView.carouselDataArray = ["defaultuse.jpg","B_Champagne Saucer.jpg","B_Beer Glassware.jpg","B_Champagne Flute.jpg"]
        carouselView.loadCarouselDataThenStart()
        
        self.view.addSubview(carouselView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.scrollView != nil){//iPhone的滚动
            //var size = desc.text.textSizeWithFont(desc.font, constrainedToSize: CGSize(width:306, height:1000))
            scrollView.contentSize = CGSize(width: 320, height: 800)
            self.view.layoutIfNeeded()
        }
    }
    
    func carouselView(carouselView: DHCarouselView, didSelectedPageAtIndex index: NSInteger) {
        //
    }
}