//
//  ViewController.swift
//  swiftPlane
//
//  Created by 张智华 on 2019/1/24.
//  Copyright © 2019年 张智华. All rights reserved.
//

import UIKit
import CoreFoundation

class ViewController: UIViewController {
    
    var bgview1: UIImageView!
    var bgview2: UIImageView!
    var planeView: UIImageView!
    var zidanArray: NSMutableArray!
    var dijiArray: NSMutableArray!
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib NSLog zhang zhi hua
        initView()
        createZiDan()
        createDiJi()
        self.starMethod()
        
    }
    
    
    
    func initView(){
        
        self.bgview1 = UIImageView.init()
        bgview1.image = UIImage(named: "bg")
        self.bgview1.frame = CGRect(x:0, y:0 , width:self.view.frame.width, height:self.view.frame.height)
        self.view.addSubview(bgview1)
        
        self.bgview2 = UIImageView.init()
        bgview2.image = UIImage(named: "bg")
        self.bgview2.frame = CGRect(x:0, y:-self.view.frame.height , width:self.view.frame.width, height:self.view.frame.height)
        self.view.addSubview(bgview2)
        
        self.planeView = UIImageView()
        //        self.planeView.animationImages = [UIImage(named: "plane1"),UIImage(named: "plane2")] as? [UIImage]
        self.planeView.image = UIImage(named: "plane1")
        
        self.planeView.frame = CGRect(x:self.view.frame.width/2 - 20 , y:self.view.frame.height - 60 , width:40 , height:40)
        //        self.planeView.backgroundColor = .red
        
        self.view.addSubview(self.planeView)
    }
    
    func createZiDan(){
        self.zidanArray = NSMutableArray()
        for _ in 1...30{
            let zidan = UIImageView.init()
            //            print("create a zidan !")
            zidan.image = UIImage(named:"zidan1")
            zidan.frame = CGRect(x:40 , y:-40 , width:10 , height:40)
            zidan.tag = 6
            self.view.addSubview(zidan)
            self.zidanArray.add(zidan)
        }
    }
    
    func createDiJi(){
        self.dijiArray = NSMutableArray()
        for _ in 1...30 {
            let diji = UIImageView.init()
            diji.image = UIImage(named:"diji")
            
            diji.tag = 6
            self.view.addSubview(diji)
            self.dijiArray.add(diji)
        }
    }
    
    
    func jihuo(){
        for zidan in self.zidanArray{
            //            print("\(zidan)")
            if (zidan as! UIImageView).tag==6{
                (zidan as! UIImageView).tag = 5
                (zidan as! UIImageView).center = self.planeView.center
                (zidan as! UIImageView).bounds = CGRect(x:0,y:0,width:10,height:40)
                break
            }
        }
        
    }
    
    
    func jihuoDiji(){
        for diji in self.dijiArray{
            //            print("\(zidan)")
            if (diji as! UIImageView).tag==6{
                (diji as! UIImageView).tag = 5
                let randomnum : Int = Int(self.view.frame.width)
                let randomNumberTwo:Int = abs(Int(arc4random_uniform(UInt32(randomnum)))-40)
                (diji as! UIImageView).frame = CGRect(x:randomNumberTwo , y:-40 , width:40 , height:40)
                break
            }
        }
        
    }
    
    
    
    
    func movezidan(){
        for zidan in self.zidanArray{
            if((zidan as! UIImageView).tag==5){
                var temp = (zidan as! UIImageView).frame
                temp.origin.y -= 30
                (zidan as! UIImageView).frame = temp
                if(temp.origin.y < -30){
                    (zidan as! UIImageView).tag=6
                    (zidan as! UIImageView).frame = CGRect.zero
                }
                
            }
        }
        
        for diji in self.dijiArray {
            if((diji as! UIImageView).tag==5){
                var temp = (diji as! UIImageView).frame
                temp.origin.y += 5
                (diji as! UIImageView).frame = temp
                if(temp.origin.y > self.view.frame.height){
                    (diji as! UIImageView).tag=6
                    (diji as! UIImageView).frame = CGRect.zero
                }
            }
        }
    }
    
    func pengzhuangDijiAndZidan() {
        for diji in self.dijiArray {
            if((diji as! UIImageView).tag==5){
                for zidan in self.zidanArray{
                    if((zidan as! UIImageView).tag==5){
                        if((diji as! UIImageView).frame.intersects((zidan as! UIImageView).frame)){
                            print("碰撞了")
                            (zidan as! UIImageView).tag=6
                            (diji as! UIImageView).tag=6
                            (zidan as! UIImageView).frame = CGRect.zero
                            (diji as! UIImageView).frame = CGRect.zero
                            
                            //CGRectIntersectsRect
//                            CGRect.intersects(<#T##CGRect#>)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func starMethod(){
        let timer =  Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(update), userInfo: "parameter", repeats: true)
        
        //        RunLoop.current.add(Timer:timer, forMode: RunLoop.Mode)
        //        let loop = RunLoop.current
        //        loop.add(Port(), forMode:RunLoop.Mode.common)
        //        loop.run()
        //
        //        RunLoop.current.add(timer, forMode:RunLoop.Mode.common)
        //        RunLoop.current.run()
        
    }
    
    
    @objc func update(){
        
        if(bgview1.frame.origin.y > self.view.frame.height){
            bgview2.frame.origin.y = -self.view.frame.height
            bgview1.frame.origin.y = 0
        }
        
        bgview1.frame.origin.y += 5
        bgview2.frame.origin.y += 5
        
        self.count = self.count+1
        
        if count%3==0{
            jihuo()
            
        }
        if count%10==0{
            jihuoDiji()
        }
        
        
        movezidan()
        pengzhuangDijiAndZidan()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        print("touch began")
        
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            //当在屏幕上连续拍动两下时，背景回复为白色
            if t.tapCount == 2
            {
                self.view.backgroundColor = UIColor.white
            }else if t.tapCount == 1
            {
                self.view.backgroundColor = UIColor.blue
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        event.
        
        var touchlocation = touches.first
//        print("\(touchlocation?.location(in: self.view))")
        self.planeView.center = (touchlocation?.location(in: self.view))!
    }
    
    
    
    
}


