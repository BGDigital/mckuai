//
//  BaseTableViewController.swift
//  v2ex
//
//  Created by liaojinxing on 14-10-16.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, UIScrollViewDelegate {
    
    var datasource: Array<JSON>! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var CBSH_Refresh = CBStoreHouseRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.CBSH_Refresh = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "onPullToFresh", plist: "storehouse", color: UIColor.blackColor(), lineWidth: 1.5, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: true, internalAnimationFactor: 0.5)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.CBSH_Refresh.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.CBSH_Refresh.scrollViewDidEndDragging()
    }
}
