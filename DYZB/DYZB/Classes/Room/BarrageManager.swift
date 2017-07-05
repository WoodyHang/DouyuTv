//
//  BarrageManager.swift
//  DYZB
//
//  Created by Woodyhang on 2017/7/2.
//  Copyright © 2017年 小码哥. All rights reserved.
//

import UIKit

class BarrageManager: NSObject {

    /**弹幕的数据来源**/
    public lazy var dataSource :[String] = {

        let arr = ["1111111~~~",
                   "@@@@!22222!~~",
                   "@#####333333~~~",
                   "444444~~~",
                   "@@@@!555555!~~",
                   "@#####66666666~~~",
                   "777777777~~~",
                   "@@@@!8888888888!~~",
                   "@#####99999999999~~~",
                   "1111111~~~",
                   "@@@@!22222!~~",
                   "@#####333333~~~",
                   "1111111~~~",
                   "@@@@!22222!~~",
                   "@#####333333~~~"]
        return arr
    }()

    /*弹幕的数组变量*/
    var barrageContent = Array<String>()
    /**弹幕view**/
    var barrageViews = Array<BarrageRenderer>()
    var animationIsStop = true

    var generateViewHandler:((BarrageRenderer) -> Swift.Void)?

    fileprivate func initBarrageString(){
        var trajectorys = [1,2,3]
        let count = trajectorys.count
        for _ in 0..<count{
            if barrageContent.count > 0 {
                let index = Int(arc4random())%trajectorys.count
                let trajectory = (trajectorys as! NSMutableArray).object(at: index)
                trajectorys.remove(at: index)
                let displayStr = barrageContent.first
                barrageContent.remove(at: 0)
                self.createBarrage(withDisplaySre: displayStr!, withTrajectory: trajectory as! Int)

            }
        }
    }

    public func start(){

        if !animationIsStop {
            return
        }
        animationIsStop = false
        self.barrageViews.removeAll()
        self.barrageContent = self.dataSource
        self.initBarrageString()    

    }

    public func stop(){

        if animationIsStop {
            return
        }

        animationIsStop = true

        for view in self.barrageViews {
            view.stopAnimation()
            view.removeFromSuperview()
        }
        self.barrageViews.removeAll()
    }
}

extension BarrageManager {

    fileprivate func createBarrage(withDisplaySre str:String,withTrajectory trajectory:Int){
        if animationIsStop {
            return
        }

        let view = BarrageRenderer(commentString: str)

        view.trajectory = trajectory

        view.moveStatusHandler = {status in
            if self.animationIsStop {
                return
            }
            switch status {
            case .start:
                self.barrageViews.append(view)
            case .enter:
                let str = self.nextString()
                guard str != nil else {
                    return
                }
                self.createBarrage(withDisplaySre: str!, withTrajectory: trajectory)
            case .end:
                if self.barrageViews.contains(view){
                     view.stopAnimation()
                    for (i,value) in self.barrageViews.enumerated(){
                        if value == view {
                            self.barrageViews.remove(at: i)

                        }
                    }
                }

                if self.barrageViews.count == 0 {
                    self.animationIsStop = true
                    self.start()
                }
            }
        }

        if generateViewHandler != nil {
            generateViewHandler!(view)
        }
    }
}

extension BarrageManager {

    fileprivate func nextString() -> String?{
        if self.barrageContent.count == 0 {
            return nil
        }
        let str = self.barrageContent.first
        self.barrageContent.remove(at: 0)
        return str
    }
}
