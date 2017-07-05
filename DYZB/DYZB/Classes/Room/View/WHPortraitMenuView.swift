//
//  WHPortraitMenuView.swift
//  DYZB
//
//  Created by Woodyhang on 2017/6/7.
//  Copyright © 2017年 小码哥. All rights reserved.
//

import UIKit

public protocol WHPortraitMenuViewDelegate :class{
    
    func portraitMenuViewDidClickedBackButton(portraitMenuView:WHPortraitMenuView)
    
    func portraitMenuView(portraitMenuView:WHPortraitMenuView,setLandScape interfaceOrientation:UIInterfaceOrientation)
}

fileprivate let margin = (kScreenW * 9 / 16 - 35 * 4 - 2 * 5) / 3
public class WHPortraitMenuView: UIView {
    
    
    public weak var delegate:WHPortraitMenuViewDelegate?
    public var isShow:Bool = true {
        didSet {
            if isShow {
                for view in self.subviews{
                    view.isHidden = false
                }
            }else {
                for view in self.subviews{
                    view.isHidden = true
                }
            }
        }
    }//竖屏菜单是否正在显示
    
    ///返回按钮
    fileprivate lazy var backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"dyla_返回_36x36_"), for: .normal)
        btn.setImage(UIImage(named:"dyla_返回pressed_36x36_"), for: .highlighted)
        btn.addTarget(self, action: #selector(WHPortraitMenuView.back(_:)), for: .touchDown)
        return btn
    }()
    
    ///分享和举报
    fileprivate lazy var moreBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"btn_v_more_34x34_"), for: .normal)
        btn.setImage(UIImage(named:"btn_v_more_h_34x34_"), for: .highlighted)
        btn.addTarget(self, action: #selector(WHPortraitMenuView.moreBtnClick(_:)), for: .touchDown)
        return btn
    }()
    
    ///送花
    fileprivate lazy var giftBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"btn_close_gift_select_36x36_"), for: .normal)
        btn.setImage(UIImage(named:"btn_close_gift_selectHighlight-1_36x36_"), for: .highlighted)
        btn.addTarget(self, action: #selector(WHPortraitMenuView.giftBtnClick(_:)), for: .touchDown)
        return btn
        
    }()
    
    ///播放和暂停
    fileprivate lazy var playOrPauseBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"btn_v_pause_36x36_"), for: .normal)
        btn.setImage(UIImage(named:"btn_v_pause_h_36x36_"), for: .highlighted)
        btn.addTarget(self, action: #selector(WHPortraitMenuView.playOrPause(_:)), for: .touchDown)
        
        return btn
    }()
    
    ///全屏按钮
    fileprivate lazy var fullScreenBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"btn_vdo_full_36x36_"), for: .normal)
        btn.setImage(UIImage(named:"btn_vdo_full_click_36x36_"), for: .highlighted)
        btn.addTarget(self, action: #selector(WHPortraitMenuView.fullScreen(_:)), for: .touchDown)
        
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        layOutViews()
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WHPortraitMenuView.hideOrShowMenuView(_:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
///布局子控件
extension WHPortraitMenuView{
    
    fileprivate func layOutViews(){
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(5)
            make.width.height.equalTo(35)
            make.top.equalTo(self.snp.top).offset(5)
        }
        
        self.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
        }
        
        self.addSubview(giftBtn)
        giftBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.top.equalTo(moreBtn.snp.bottom).offset(margin)
            make.right.equalTo(self.snp.right).offset(-5)
        }
        
        self.addSubview(playOrPauseBtn)
        playOrPauseBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.top.equalTo(giftBtn.snp.bottom).offset(margin)
            make.right.equalTo(self.snp.right).offset(-5)
        }
        
        self.addSubview(fullScreenBtn)
        fullScreenBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.right.equalTo(self.snp.right).offset(-5)
        }
    }
}

///按钮点击事件
extension WHPortraitMenuView{
    @objc fileprivate func back(_ sender:UIButton){
        delegate?.portraitMenuViewDidClickedBackButton(portraitMenuView: self)
    }
    
    @objc fileprivate func moreBtnClick(_ sender:UIButton){
        
    }
    
    @objc fileprivate func giftBtnClick(_ sender:UIButton){
        
    }
    
    @objc fileprivate func playOrPause(_ sender:UIButton){
        
    }
    
    @objc fileprivate func fullScreen(_ sender:UIButton){
        delegate?.portraitMenuView(portraitMenuView: self, setLandScape: .landscapeRight)
    }
    
    ///显示或隐藏菜单view
    @objc fileprivate func hideOrShowMenuView(_ sender:UITapGestureRecognizer){
        if isShow{
            isShow = false
        }else {
            isShow = true
        }
    }
}
