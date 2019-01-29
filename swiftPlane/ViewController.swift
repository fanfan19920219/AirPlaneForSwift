//
//  ViewController.swift
//  swiftPlane
//
//  Created by 张智华 on 2019/1/24.
//  Copyright © 2019年 张智华. All rights reserved.
//

import UIKit
import CoreFoundation

let planeWidth = CGFloat(33.0)
let planeHeight = CGFloat(40.0)

let dijiWidth = CGFloat(37.0)
let dijiHeight = CGFloat(30.0)

let kScreenHeight = CGFloat(UIScreen.main.bounds.size.height)
let kScreenWidth = CGFloat(UIScreen.main.bounds.size.width)



class ViewController: UIViewController {
    
    var Hertz:Double = 35.0 //刷屏速度
    
    var centerButton:UIButton!
    
    var bgview1: UIImageView!
    var bgview2: UIImageView!
    var planeView: UIImageView!
    var zidanArray: NSMutableArray!
    var dijiArray: NSMutableArray!
    var scoreLabel: UILabel!
    var count = 0      //计数器
    var score = 0      //分数
    var zidanNum = 30  //子弹总数
    var dijiNum = 30   //敌机总数
    var timer:Timer!
    
    var activeZiDanNum:Int = 3 //控制子弹的发射密集程度
    var activeDiJiNum:Int = 10 //控制敌机的下落速度
    var DiJiSpace:CGFloat = 4.0 //控制敌机的速度
    var ZiDanSpace:CGFloat = 30.0 //控制子弹的速度
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        createZiDan()
        createDiJi()
        //缓冲
        createBoomView(CGRect.zero)
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
        var imgArray = [UIImage]();
        for i in 1 ... 2{
            imgArray.append(UIImage(named:"plane\(i)")!)
        }
        self.planeView.animationImages=imgArray
        self.planeView.startAnimating()
        
        self.planeView.frame = CGRect(x:self.view.frame.width/2 - 20 , y:self.view.frame.height - 60 , width:planeWidth , height:planeHeight)
        //        self.planeView.backgroundColor = .red
        
        self.view.addSubview(self.planeView)
        
        self.centerButton = UIButton()
        self.centerButton.setTitle("开始游戏", for: .normal)
        self.centerButton.setTitleColor(.red, for: .normal)
        self.centerButton.addTarget(self, action: #selector(star), for: .touchUpInside)
        self.centerButton.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.centerButton.bounds = CGRect(x:0,y:0,width:80,height:20)
        self.view.addSubview(self.centerButton)
        
        
        self.scoreLabel = UILabel()
        self.scoreLabel.frame = CGRect(x:kScreenWidth - 100,y:kScreenHeight-30,width:80,height:20)
        self.scoreLabel.text="0"
        self.scoreLabel.textAlignment = NSTextAlignment.right
        self.scoreLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 2))
        self.view.addSubview(self.scoreLabel)
        
    }
    
    @objc func star(){
        self.starMethod()
        self.centerButton.alpha = 0
    }
    
    
    func createZiDan(){
        self.zidanArray = NSMutableArray()
        for _ in 1...self.zidanNum{
            let zidan = UIImageView.init()
            //            print("create a zidan !")
            zidan.image = UIImage(named:"zidan1")
            zidan.frame = CGRect(x:40 , y:-40 , width:3 , height:20)
            zidan.tag = 6
            self.view.addSubview(zidan)
            self.zidanArray.add(zidan)
        }
    }
    
    func createDiJi(){
        self.dijiArray = NSMutableArray()
        for _ in 1...self.dijiNum {
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
                (zidan as! UIImageView).bounds = CGRect(x:0,y:0,width:4,height:15)
                break
            }
        }
        
    }
    
    
    func jihuoDiji(){
        for diji in self.dijiArray{
            //            print("\(zidan)")
            if (diji as! UIImageView).tag==6{
                (diji as! UIImageView).tag = 5
                let randomnum : CGFloat = self.view.frame.width
                let randomNumberTwo:CGFloat = abs(CGFloat(arc4random_uniform(UInt32(randomnum)))-dijiHeight)
                (diji as! UIImageView).frame = CGRect(x:randomNumberTwo , y:-dijiHeight , width:dijiWidth , height:dijiHeight)
                break
            }
        }
        
    }
    
    
    func movezidan(){
        for zidan in self.zidanArray{
            if((zidan as! UIImageView).tag==5){
                var temp = (zidan as! UIImageView).frame
                temp.origin.y -= self.ZiDanSpace
                (zidan as! UIImageView).frame = temp
                if(temp.origin.y < -30){
                    (zidan as! UIImageView).tag = 6
                    (zidan as! UIImageView).frame = CGRect.zero
                }
                
            }
        }
        
        for diji in self.dijiArray {
            if((diji as! UIImageView).tag==5){
                var temp = (diji as! UIImageView).frame
                temp.origin.y += self.DiJiSpace
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
                            (zidan as! UIImageView).tag=6
                            (diji as! UIImageView).tag=6
                            createBoomView((diji as! UIImageView).frame)
                            (zidan as! UIImageView).frame = CGRect.zero
                            (diji as! UIImageView).frame = CGRect.zero
                            score += 10
                            self.scoreLabel.text = String(format:"%d", score)
                        }
                    }
                }
            }
        }
    }
    
    func createBoomView(_ frame:CGRect){
        let boomView:UIImageView = UIImageView()
        boomView.frame = frame
        self.view.addSubview(boomView)
        var imgArray = [UIImage]();
        for i in 1 ... 5{
            imgArray.append(UIImage(named:"bz\(i)")!)
        }
        // 给动画数组赋值
        boomView.animationImages = imgArray
        // 设置重复次数, 学过的都知道...0 代表无限循环,其他数字是循环次数,负数效果和0一样...
        boomView.animationRepeatCount = 1
        // 动画完成所需时间
        boomView.animationDuration = 0.5
        // 开始动画
        boomView.startAnimating()
    }
    
    
    func starMethod(){
//        CGFloat Hertz = CGFloat(1.0/self.Hertz)
        
        self.timer =  Timer.scheduledTimer(timeInterval:1.0/self.Hertz, target: self, selector: #selector(update), userInfo: "parameter", repeats: true)
        
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
        
        if count%self.activeZiDanNum==0{
            jihuo()
            
        }
        if count%self.activeDiJiNum==0{
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
        //a
    }
    
}


