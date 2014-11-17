//
//  Welcome.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/9/24.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit

class Welcome: UIViewController , UIGestureRecognizerDelegate {
    
    @IBOutlet var page1_bg:UIImageView!
    @IBOutlet var page2_bg:UIImageView!
    @IBOutlet var page3_bg:UIImageView!
    @IBOutlet var page4_bg:UIImageView!
    
    @IBOutlet var page1_content:UIImageView!
    @IBOutlet var page2_content:UIImageView!
    @IBOutlet var page3_content:UIImageView!
    @IBOutlet var page4_content:UIImageView!
    
    
    @IBOutlet var page1_desc:UIImageView!
    @IBOutlet var page2_desc:UIImageView!
    @IBOutlet var page3_desc:UIImageView!
    @IBOutlet var page4_desc:UIImageView!
    
    @IBOutlet var pageControl:UIPageControl!
    
    @IBOutlet var startButton:UIButton!
    
    var panGesture:UIPanGestureRecognizer!
    
    var maxpan:CGFloat = 400
    
    var current_bg:UIImageView!
    var current_content:UIImageView!
    var current_desc:UIImageView!
    
    var show_bg:UIImageView!
    var show_content:UIImageView!
    var show_desc:UIImageView!
    
    var currentIndex:Int = 1
    
    let animationTime:CGFloat=1
    
    let contentPlus:CGFloat=2
    let descPlus:CGFloat=3
    var direction:Bool=false
    
    var firstPop:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 4
        page2_bg.alpha = 0
        page2_content.alpha = 0
        page2_desc.alpha = 0
        
        page3_bg.alpha = 0
        page3_content.alpha = 0
        page3_desc.alpha = 0
        
        page4_bg.alpha = 0
        page4_content.alpha = 0
        page4_desc.alpha = 0
        
        current_bg = page1_bg
        current_content = page1_content
        current_desc = page1_desc
        
        panGesture = UIPanGestureRecognizer(target:self, action: "pan:")
        self.view.addGestureRecognizer(panGesture)
        self.view.userInteractionEnabled = true
        
    }
    

    
    func pan(sender:UIPanGestureRecognizer){
        var currentPostion = sender.translationInView(self.view)
        if (self.panGesture.state == UIGestureRecognizerState.Began) {
            current_bg=(self.valueForKey("page\((currentIndex))_bg") as UIImageView!)
            current_content=(self.valueForKey("page\((currentIndex))_content") as UIImageView!)
            current_desc=(self.valueForKey("page\((currentIndex))_desc") as UIImageView!)
        }else if(self.panGesture.state == UIGestureRecognizerState.Ended){
            if(show_bg != nil){
                pageToShowAnimate(currentPostion.x)
                panToHideAnimate(currentPostion.x)
                if(currentPostion.x>maxpan/2){
                    currentIndex--
                }else if(currentPostion.x<(-maxpan/2)){
                    currentIndex++
                }
                
                if(currentIndex==4){
                    startButton.alpha=1
                }else{
                    startButton.alpha=0
                }
                pageControl.currentPage = currentIndex-1
            }
        }else{
            if((currentIndex<4) && currentPostion.x < -20 && currentPostion.x>(-maxpan)){//向左滑动
                if(show_bg == nil || direction){
                    show_bg=(self.valueForKey("page\((currentIndex+1))_bg") as UIImageView!)
                    show_content=(self.valueForKey("page\((currentIndex+1))_content") as UIImageView!)
                    show_desc=(self.valueForKey("page\((currentIndex+1))_desc") as UIImageView!)
                    direction = false
                }
                panToHide(currentPostion.x);
                pageToShow(currentPostion.x);
            } else if((currentIndex>1) && currentPostion.x>20 && currentPostion.x<maxpan){//向右滑动
                if(show_bg == nil || !direction){
                    show_bg=(self.valueForKey("page\((currentIndex-1))_bg") as UIImageView!)
                    show_content=(self.valueForKey("page\((currentIndex-1))_content") as UIImageView!)
                    show_desc=(self.valueForKey("page\((currentIndex-1))_desc") as UIImageView!)
                    direction = true
                }
                panToHide(currentPostion.x);
                pageToShow(currentPostion.x);
            }
        }
        
    }
    
    func pageToShow(offset:CGFloat){
        var alph = abs(offset/maxpan)
        show_bg.alpha = alph
        show_content.alpha = alph
        show_desc.alpha = alph
        if(offset<0){
            show_content.frame = CGRect(x:(maxpan+offset)*contentPlus, y: 0, width: show_content.frame.width, height: show_content.frame.height)
            show_desc.frame = CGRect(x: (maxpan+offset)*descPlus, y: 0, width: show_desc.frame.width, height: show_desc.frame.height)
        }else{
            show_content.frame = CGRect(x:(offset-maxpan)*contentPlus, y: 0, width: show_content.frame.width, height: show_content.frame.height)
            show_desc.frame = CGRect(x: (offset-maxpan)*descPlus, y: 0, width: show_desc.frame.width, height: show_desc.frame.height)
        }
    }
    
    func pageToShowAnimate(offset:CGFloat){
        
        if(self.show_bg != nil){
            var anitime:CGFloat = (maxpan-abs(offset))/maxpan*animationTime
            
            var ialpha:CGFloat = 1
            var ioffset:CGFloat = 0
            
            if(abs(offset)<maxpan/2){//尚未移动一半
                ialpha = 0
                if(offset<0){
                    ioffset = maxpan
                }else{
                    ioffset = -maxpan
                }
                anitime = abs(offset)/maxpan*animationTime
            }
            
            UIView.animateWithDuration(NSTimeInterval(anitime), delay: 0, options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.show_bg.alpha = ialpha
                    self.show_content.alpha = ialpha
                    self.show_desc.alpha = ialpha
                    self.show_content.frame = CGRect(x: ioffset*self.contentPlus, y: 0, width: self.show_content.frame.width, height: self.show_content.frame.height)
                    self.show_desc.frame = CGRect(x: ioffset*self.descPlus, y: 0, width: self.show_desc.frame.width, height: self.show_desc.frame.height)
                }, completion: { _ in
                    self.show_bg = nil
            })
        }
        
    }
    
    func panToHide(offset:CGFloat){
        if(offset<0){
            current_content.frame = CGRect(x: offset*contentPlus, y: 0, width: current_content.frame.width, height: current_content.frame.height)
            current_desc.frame = CGRect(x: offset*descPlus, y: 0, width: current_content.frame.width, height: current_content.frame.height)
        }else{
            current_content.frame = CGRect(x: offset*contentPlus, y: 0, width: current_content.frame.width, height: current_content.frame.height)
            current_desc.frame = CGRect(x: offset*descPlus, y: 0, width: current_content.frame.width, height: current_content.frame.height)
        }
        var alph = 1-abs(offset/maxpan)
        current_content.alpha = alph
        current_desc.alpha = alph
        current_bg.alpha = alph
    }
    
    func panToHideAnimate(offset:CGFloat){
        if(self.show_bg != nil){
            var anitime:CGFloat = (maxpan-abs(offset))/maxpan*animationTime
            
            var ialpha:CGFloat = 0
            var ioffset:CGFloat = -maxpan
            if(offset>0){
                ioffset = maxpan
            }
            if(abs(offset)<maxpan/2){//尚未移动一半
                ialpha = 1
                ioffset = 0
                anitime = abs(offset)/maxpan*animationTime
            }
            
            UIView.animateWithDuration(NSTimeInterval(anitime), delay: 0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.current_content.alpha = ialpha
                    self.current_desc.alpha = ialpha
                    self.current_bg.alpha = ialpha
                    self.current_content.frame = CGRect(x: ioffset*self.contentPlus, y: 0, width: self.current_content.frame.width, height: self.current_content.frame.height)
                    self.current_desc.frame = CGRect(x: ioffset*self.descPlus, y: 0, width: self.current_content.frame.width, height: self.current_content.frame.height)
                }, completion: nil)
        }
    }
    
    @IBAction func clicktoHidden(sender:UIButton){
        UIView.animateWithDuration(0.3,
            animations : {
                self.view.alpha = 0
            },
            completion : {_ in
                if(self.firstPop){
                    self.view.removeFromSuperview()
                }else{
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
