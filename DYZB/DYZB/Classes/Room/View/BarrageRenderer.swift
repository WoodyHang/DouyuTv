//
//  BarrageRenderer.swift
//  DYZB
//
//  Created by Woodyhang on 2017/6/30.
//  Copyright © 2017年 小码哥. All rights reserved.
//

import UIKit
/**弹幕**/
fileprivate let Padding:CGFloat = 10
fileprivate let BarrageH:CGFloat = 30
fileprivate let textFont = UIFont.systemFont(ofSize: 14)
fileprivate let duration = 10.0
fileprivate let Speed = 100.0
enum WH_moveStutus:String {
    case start
    case enter
    case end
}

class BarrageRenderer: UIView {

    fileprivate lazy var bodyLabel:UILabel = {

        let label = UILabel()
        label.font = textFont
        label.backgroundColor = UIColor.red
        return label
    }()

    /*弹道***/
    public var trajectory = 0

    typealias moveStatus = (WH_moveStutus) -> Swift.Void

    public var moveStatusHandler:moveStatus?


    public init(commentString str:String){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        let strWidth = (str as NSString).size(attributes: [NSFontAttributeName:textFont]).width
        self.addSubview(bodyLabel)

        let height:CGFloat = 30
        self.layer.cornerRadius = height / 2
        self.bounds = CGRect(x: 0, y: 0, width: strWidth + 2 * Padding, height: BarrageH)

        bodyLabel.text = str
        bodyLabel.frame = CGRect(x: Padding, y: 0, width: strWidth, height: BarrageH)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BarrageRenderer {

    public func startAnimation(){
        guard self.moveStatusHandler != nil else {
            return
        }

        self.moveStatusHandler!(.start)

        let screenW = UIScreen.main.bounds.width
        //let speed = Double(self.bounds.width + screenW) / duration

        let enterDelay = Double(self.bounds.width) / Speed

        self.perform(#selector(enterScreen), with: nil, afterDelay: enterDelay)

        var frame = self.frame

        UIView.animate(withDuration: Double(self.bounds.width + screenW) / Speed, delay: 0, options: .curveLinear, animations: {
            frame.origin.x = -self.bounds.width
            self.frame = frame
        }) { (finished) in
            if self.moveStatusHandler != nil {
                self.moveStatusHandler!(.end)
            }
        }
    }

    public func stopAnimation(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(enterScreen), object: nil)
        self.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
}

extension BarrageRenderer {
    @objc fileprivate func enterScreen(){

        if self.moveStatusHandler != nil {
            self.moveStatusHandler!(.enter)
        }
    }
}
