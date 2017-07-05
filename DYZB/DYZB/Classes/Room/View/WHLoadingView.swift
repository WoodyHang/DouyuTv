//
//  LoadingView.swift
//  DYZB
//
//  Created by Woodyhang on 2017/6/6.
//  Copyright © 2017年 小码哥. All rights reserved.
//

import UIKit

class WHLoadingView: UIView {
    
    
    
    fileprivate var animateImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.animationImages = [UIImage(named:"image_loading_player01")!,
                                     UIImage(named:"image_loading_player02")!,
                                     UIImage(named:"image_loading_player03")!,
                                     UIImage(named:"image_loading_player04")!]
        imageView.animationRepeatCount = Int(MAXINTERP)
        imageView.animationDuration = 0.5
        imageView.startAnimating()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViewsWithAnimate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimate(){
        animateImage.startAnimating()
    }
    
    public func stopAnimate(){
        animateImage.stopAnimating()
    }
}

extension WHLoadingView {
    
    ///创建subviews，以及动画
    func setUpSubViewsWithAnimate(){
        self.addSubview(animateImage)
        
        animateImage.snp.makeConstraints { (make) in
            make.width.equalTo(216)
            make.height.equalTo(self.snp.height).multipliedBy(0.7)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        //加载文字显示的·label
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "鲨鱼娘正在加载中...."
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(216)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.top.equalTo(animateImage.snp.bottom).offset(-20)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
