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
    
    var centerButton:UIButton!
    
    var bgview1: UIImageView!
    var bgview2: UIImageView!
    var planeView: UIImageView!
    var zidanArray : Array<UIImageView>!
    var dijiArray: Array<UIImageView>!
    var scoreLabel: UILabel!
    var zidanAddaLabelArray: Array<UILabel>!
    var timer:Timer!
    
    /***********************************************/
    
    var Hertz:Double = 35.0 //刷屏速度
    var count = 0      //计数器
    var score = 0      //分数
    var zidanNum = 100  //子弹总数
    var dijiNum = 100   //敌机总数
    var activeZiDanNum:Int = 3 //控制子弹的发射密集程度
    var activeDiJiNum:Int = 10 //控制敌机的下落速度
    var DiJiSpace:CGFloat = 4.0 //控制敌机的速度
    var ZiDanSpace:CGFloat = 30.0 //控制子弹的速度
    var AddZiDanSpace:CGFloat = 1 //控制子弹+1 下落的速度
    var addzidanRandomNum = 20 //控制宝贝掉落几率 %5
    
    var ZiDanStatus:Int = 0 //控制子弹的状态
    
    /***********************************************/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        createZiDan()
        createDiJi()
        createAddZiDan()
        //缓冲
        createBoomView(CGRect.zero)
        self.ZiDanStatus = 0
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
        self.score = 0
    }
    
    
    
    
    func createAddZiDan(){
        self.zidanAddaLabelArray = Array<UILabel>()
        
        for _ in 1...self.dijiNum {
            var zidanAddaLabel = UILabel()
            zidanAddaLabel.text = "+1"
            zidanAddaLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.001))
            zidanAddaLabel.textColor = .black
            zidanAddaLabel.textAlignment = NSTextAlignment.center
            zidanAddaLabel.layer.cornerRadius = 10
            zidanAddaLabel.clipsToBounds = true
            zidanAddaLabel.tag = 6
            zidanAddaLabel.frame = CGRect.zero
            self.zidanAddaLabelArray.append(zidanAddaLabel)
            self.view.addSubview(zidanAddaLabel)
        }
    }
    
    func createZiDan(){
        self.zidanArray = Array<UIImageView>()
        for _ in 1...self.zidanNum{
            let zidan = UIImageView.init()
            //            print("create a zidan !")
            zidan.image = UIImage(named:"zidan1")
            zidan.frame = CGRect(x:40 , y:-40 , width:3 , height:20)
            zidan.tag = 6
            self.view.addSubview(zidan)
            self.zidanArray.append(zidan)
        }
    }
    
    func createDiJi(){
        self.dijiArray = Array<UIImageView>()
        for _ in 1...self.dijiNum {
            let diji = UIImageView.init()
            diji.image = UIImage(named:"diji")
            diji.tag = 6
            self.view.addSubview(diji)
            self.dijiArray.append(diji)
        }
    }
    
    func jihuo(){
        for zidan in self.zidanArray{
            //            print("\(zidan)")
            if zidan.tag==6{
                zidan.tag = 5
                zidan.center = self.planeView.center
                zidan.bounds = CGRect(x:0,y:0,width:4,height:15)
                break
            }
        }
    }
    
    func jihuo1(){
        
        var x  = self.planeView.center.x
        var y  = self.planeView.center.y
        var pointArray = [CGPoint(x:x-10,y:y),CGPoint(x:x+10,y:y)]
        
        var i:Int = 0
        for zidan in self.zidanArray{
            //            print("\(zidan)")
            if (zidan.tag==6){
                zidan.tag = 5
                zidan.center = pointArray[i]
                zidan.bounds = CGRect(x:0,y:0,width:4,height:15)
                i=i+1
                if(i==2){
                    i=0
                    break
                }
            }
        }
        
//        for zidan in self.zidanArray{
//            //            print("\(zidan)")
//            if (zidan as! UIImageView).tag==6{
//                (zidan as! UIImageView).tag = 5
//                (zidan as! UIImageView).center = pointArray[1]
//                (zidan as! UIImageView).bounds = CGRect(x:0,y:0,width:4,height:15)
//                break
//            }
//        }
        
    }
    
    
    func jihuo2(){
        
        var x  = self.planeView.center.x
        var y  = self.planeView.center.y
        var pointArray = [CGPoint(x:x-10,y:y),CGPoint(x:x+10,y:y),CGPoint(x:x,y:y)]
        
        var i:Int = 0
        for zidan in self.zidanArray{
            //            print("\(zidan)")
            if (zidan.tag==6){
                zidan.tag = 5
                zidan.center = pointArray[i]
                zidan.bounds = CGRect(x:0,y:0,width:4,height:15)
                i=i+1
                if(i==3){
                    i=0
                    break
                }
            }
        }
    }
    
    
    func jihuo3(){
        
        var x  = self.planeView.center.x
        var y  = self.planeView.center.y
        var pointArray = [CGPoint(x:x-5,y:y),CGPoint(x:x+5,y:y),CGPoint(x:x+15,y:y),CGPoint(x:x-15,y:y)]
        
        var i:Int = 0
        for zidan in self.zidanArray{
            //            print("\(zidan)")
            if (zidan.tag==6){
                zidan.tag = 5
                zidan.center = pointArray[i]
                zidan.bounds = CGRect(x:0,y:0,width:4,height:15)
                i=i+1
                if(i==4){
                    i=0
                    break
                }
            }
        }
    }
    
    
    
    func jihuoDiji(){
        for diji in self.dijiArray{
            //            print("\(zidan)")
            if (diji.tag==6){
                diji.tag = 5
                let randomnum : CGFloat = self.view.frame.width
                let randomNumberTwo:CGFloat = abs(CGFloat(arc4random_uniform(UInt32(randomnum)))-dijiHeight)
                diji.frame = CGRect(x:randomNumberTwo , y:-dijiHeight , width:dijiWidth , height:dijiHeight)
                break
            }
        }
    }
    
    
    func movezidan(){
        for zidan in self.zidanArray{
            if(zidan.tag==5){
                var temp = zidan.frame
                temp.origin.y -= self.ZiDanSpace
                zidan.frame = temp
                if(temp.origin.y < -30){
                    zidan.tag = 6
                    zidan.frame = CGRect.zero
                }
            }
        }
        
        
        for diji in self.dijiArray {
            if(diji.tag==5){
                var temp = diji.frame
                temp.origin.y += self.DiJiSpace
                diji.frame = temp
                if(temp.origin.y > self.view.frame.height){
                    diji.tag=6
                    diji.frame = CGRect.zero
                }
            }
        }
        
        for addZidan in self.zidanAddaLabelArray{
            if(addZidan.tag==5){
                var temp = addZidan.frame
                temp.origin.y += self.AddZiDanSpace
                addZidan.frame = temp
                if(temp.origin.y > self.view.frame.height){
                    addZidan.tag=6
                    addZidan.frame = CGRect.zero
                }
            }
        }
        
        
//        if(self.zidanAddaLabel.tag==1){
//            var temp = self.zidanAddaLabel.frame
//            temp.origin.y += self.DiJiSpace
//            self.zidanAddaLabel.frame = temp
//
//
//        }
    }
    
    
    func pengzhuangDijiAndZidan() {
        for diji in self.dijiArray {
            if(diji.tag==5){
                
                
                for zidan in self.zidanArray{
                    if(zidan.tag==5){
                        if(diji.frame.intersects(zidan.frame)){
                            zidan.tag=6
                            diji.tag=6
                            createBoomView(diji.frame)
                            
                            for addzidan in self.zidanAddaLabelArray{
                                if(addzidan.tag==6){
                                    if((arc4random_uniform(UInt32(100)))<self.addzidanRandomNum){
                                        addzidan.tag = 5
                                        addzidan.frame = diji.frame
                                    }
                                    break
                                }
                            }
                            //self.zidanAddaLabel.frame = (diji as! UIImageView).frame
                            zidan.frame = CGRect.zero
                            diji.frame = CGRect.zero
                            score += 10
                            self.scoreLabel.text = String(format:"%d", score)
                            
                        }
                    }
                }
                if((diji.frame.intersects(self.planeView.frame))){
                    stopGame()
                }
            }
        }
    }
    
    func pengzhuangADDZidan() {
        for addzidan in self.zidanAddaLabelArray{
            if(addzidan.tag == 5){
                if(addzidan.frame.intersects(self.planeView.frame)){
                    addzidan.tag = 6
                    addzidan.frame = CGRect.zero
                    self.ZiDanStatus += 1
                    if(self.ZiDanStatus>20){
                        activeZiDanNum = 2
                    }
                    self.score += 100
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
    
    func stopGame(){
        self.timer.invalidate()
        
        self.ZiDanStatus = 0
        self.centerButton.alpha = 1
        clean()
    }
    
    func clean(){
        for diji in self.dijiArray{
            diji.tag = 6
            diji.frame = CGRect.zero
        }
        for zidan in self.zidanArray{
            zidan.tag = 6
            zidan.frame = CGRect.zero
        }
        for addzidan in self.zidanAddaLabelArray{
            addzidan.tag = 6
            addzidan.frame = CGRect.zero
        }
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
            if(self.ZiDanStatus==0){
                jihuo()
            }
            
            if(self.ZiDanStatus==1){
                jihuo1()
            }
            
            if(self.ZiDanStatus==2){
                jihuo2()
            }
            
            if(self.ZiDanStatus>=3){
                jihuo3()
            }
            
        }
        
        if count%self.activeDiJiNum==0{
            jihuoDiji()
        }
        
        movezidan()
        pengzhuangDijiAndZidan()
        pengzhuangADDZidan()
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


