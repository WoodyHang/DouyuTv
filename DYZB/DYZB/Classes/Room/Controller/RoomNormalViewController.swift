//
//  RoomNormalViewController.swift
//  DYZB
//
//  Created by 1 on 16/10/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
import IJKMediaFramework

fileprivate let margin = 20
class RoomNormalViewController: UIViewController, UIGestureRecognizerDelegate{

    fileprivate lazy var playerVc:IJKFFMoviePlayerController = {

        let playvc = IJKFFMoviePlayerController(contentURLString: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8", with: nil)
        //playvc?.prepareToPlay()
        playvc?.shouldAutoplay = true
        return playvc!
    }()

    /**弹幕管理者**/
    fileprivate lazy var barrageManager:BarrageManager = {
        let manager = BarrageManager()
        return manager
    }()

    /*
     *遮盖view
     **/
    fileprivate lazy var blackCoverView:UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        return coverView
    }()

    ///加载动画view

    fileprivate lazy var loadingView:WHLoadingView = {
        let loadview = WHLoadingView(frame: CGRect(x: 0, y: 20, width: kScreenW, height: kScreenW * 9 / 16))
        loadview.backgroundColor = UIColor.black
        return loadview
    }()

    ///竖屏下的菜单view
    fileprivate lazy var portraitMenuView:WHPortraitMenuView = {
        let view = WHPortraitMenuView(frame: CGRect(x: 0, y: 20, width: kScreenW, height: kScreenW * 9 / 16))
        view.delegate = self
        return view

    }()
    ///横屏下的菜单view
    fileprivate lazy var landScapeMenuView:WHLandScapeMenuView = {
        let view = WHLandScapeMenuView.landScapeMenuView()
        view.delegate = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        (UIApplication.shared.delegate as! AppDelegate).allowRotation = 1
        layOutViews()

        registerMovieNotification()

        listeningRotation()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)

        //        停止播放
        playerVc.pause()
        playerVc.stop()
        playerVc.shutdown()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RoomNormalViewController {

    /*
     *布局视图
     */
    fileprivate func layOutViews(){

        view.addSubview(self.blackCoverView)
        blackCoverView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(kScreenW * 9 / 16 + 20)
        }

        ///添加播放器view
        blackCoverView.insertSubview(playerVc.view, at: 0)
        playerVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(blackCoverView.snp.top).offset(margin)
            make.left.equalTo(blackCoverView.snp.left)
            make.right.equalTo(blackCoverView.snp.right)
            make.bottom.equalTo(blackCoverView.snp.bottom)
        }

        //添加一个加载动画的imageview
        blackCoverView.insertSubview(loadingView, at: 0)
        loadingView.startAnimate()

        //添加竖屏的菜单view
        blackCoverView.insertSubview(portraitMenuView, aboveSubview: playerVc.view)

        /**
         预加载横屏的memu，先不给frame
         *
         */
        blackCoverView.addSubview(landScapeMenuView)
        landScapeMenuView.isHidden = true
        landScapeMenuView.isShow = false

        //添加弹幕
        self.barrageManager.generateViewHandler = {(view) in

            self.addBarrageView(view: view)
        }

        //发送弹幕
        landScapeMenuView.sendBarrage = { [weak self](barrageStr) in
            //计算发送的弹幕应该放在刚播完的弹幕之后
            let existBarrageNum = (self?.barrageManager.dataSource.count)! - (self?.barrageManager.barrageContent.count)!
            if self?.barrageManager.barrageContent.count == 0 {
                //弹幕播完，直接追加到数组中
                self?.barrageManager.barrageContent.append(barrageStr)
                self?.barrageManager.dataSource.append(barrageStr)

            }else {
                self?.barrageManager.barrageContent.insert(barrageStr, at: 0)
                self?.barrageManager.dataSource.insert(barrageStr, at: existBarrageNum)

            }
        }
    }
    ///布局竖屏视图
    fileprivate func setOrientationPortrait(){
        blackCoverView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(kScreenW * 9 / 16 + 20)
        }

        playerVc.view.snp.updateConstraints { (make) in
            make.top.equalTo(blackCoverView.snp.top).offset(margin)
            make.left.equalTo(blackCoverView.snp.left)
            make.right.equalTo(blackCoverView.snp.right)
            make.bottom.equalTo(blackCoverView.snp.bottom)

        }

        loadingView.frame = CGRect(x: 0, y: 20, width: view.frame.size.width, height: kScreenW * 9 / 16 + 20)

        //self.prefersStatusBarHidden = true

        ///隐藏竖屏的菜单view
        portraitMenuView.isHidden = false
        landScapeMenuView.isHidden = true

        //切换到竖屏，停止弹幕
        barrageManager.stop()

    }
    ///布局视图，横屏,同时加上弹幕
    fileprivate func setOrientationLandscape(){
        landScapeMenuView.isShow = false
        blackCoverView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.frame.size.height)
        }

        playerVc.view.snp.updateConstraints { (make) in
            make.edges.equalTo(blackCoverView.snp.edges)
        }

        landScapeMenuView.snp.makeConstraints { (make) in
            make.top.equalTo(blackCoverView.snp.top)
            make.left.equalTo(blackCoverView.snp.left)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }

        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.height)

        //self.prefersStatusBarHidden = true

        ///隐藏竖屏的菜单view
        portraitMenuView.isHidden = true
        landScapeMenuView.isHidden = false

        //默认开启弹幕
        barrageManager.start()

    }
}

extension RoomNormalViewController {
    ///注册监听 ，监听播放器的状态
    fileprivate func registerMovieNotification(){
        ///监听网络状态的改变
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadStateDidChange(_ :)),
                                               name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange,
                                               object: self.playerVc)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mediaIsPreparedToPlayDidChange(_ :)), name:NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange,
                                               object: self.playerVc)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadPlayStateDidChange(_ :)), name:NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange,
                                               object: self.playerVc)


        playerVc.prepareToPlay()
    }

    @objc fileprivate func loadStateDidChange(_ notif:Notification){
        let loadState:IJKMPMovieLoadState = self.playerVc.loadState
        print(loadState)
        if (loadState == IJKMPMovieLoadState.init(rawValue: 3))  {
            //加载完成，即将播放，停止加载的动画，并将其移除
            self.loadingView.stopAnimate()
            self.loadingView.removeFromSuperview()
            print("加载完成，自动播放 LoadStateDidChange: IJKMovieLoadStatePlayThroughOK：\(String(describing: loadState))")

        }else if loadState == IJKMPMovieLoadState.init(rawValue: 4) {
            // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
            print("自动暂停了,LoadStateDidChange: IJKMovieLoadStatePlayThroughOK：\(String(describing: loadState))")
            self.blackCoverView.insertSubview(self.loadingView, at: 1)
            self.loadingView.startAnimate()
        }else if loadState == IJKMPMovieLoadState.playable {
            print("直播进行中")
            self.playerVc.prepareToPlay()
        }else {

        }
    }

    @objc fileprivate func loadPlayStateDidChange(_ notif:Notification){
        let playState = self.playerVc.playbackState
        if playState == .interrupted{
            print("中断")
        }else if playState == .stopped{
            print("停止")
            self.blackCoverView.insertSubview(self.loadingView, at: 1)
            self.loadingView.startAnimate()
        }else if playState == .paused{
            print("暂停")
        }else if playState == .playing{
            self.playerVc.prepareToPlay()
        }
    }

    @objc fileprivate func mediaIsPreparedToPlayDidChange(_ notif:Notification){
        print("准备播放了")
    }
}

///WHPortraitMenuViewDelegate
extension RoomNormalViewController:WHPortraitMenuViewDelegate{

    func portraitMenuViewDidClickedBackButton(portraitMenuView: WHPortraitMenuView) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func portraitMenuView(portraitMenuView: WHPortraitMenuView, setLandScape interfaceOrientation: UIInterfaceOrientation) {
        self.interfaceOrientation(orientation: interfaceOrientation)
    }
}

///WHLandScapeMenuViewDelegate
extension RoomNormalViewController:WHLandScapeMenuViewDelegate{
    func landScapeMenuViewdidClickedBarrageBtn(landScapeView: WHLandScapeMenuView, isOpenBarrage openBarrage: Bool) {

        if openBarrage {
            barrageManager.start()
        }else {
            barrageManager.stop()
        }

    }


    func landScapeMenuViewDidClickedBackButton(landScapeView: WHLandScapeMenuView, setPortrait interfaceOrientation: UIInterfaceOrientation) {
        self.interfaceOrientation(orientation: interfaceOrientation)
    }
}

///强制屏幕转屏

extension RoomNormalViewController{
    fileprivate func interfaceOrientation(orientation:UIInterfaceOrientation){

        let value = orientation.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

///监听设备的旋转通知，并更改横屏和竖屏的UI
extension RoomNormalViewController{

    fileprivate func listeningRotation(){

        NotificationCenter.default.addObserver(self, selector: #selector(RoomNormalViewController.deviceOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    @objc private func deviceOrientationChanged(){

        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft:
            setOrientationLandscape()
        default:
            setOrientationPortrait()
        }
    }
}
//MARK:弹幕view初始化
extension RoomNormalViewController{
    fileprivate func addBarrageView(view:BarrageRenderer){
        self.blackCoverView.insertSubview(view, belowSubview: self.landScapeMenuView)
        let trajectory = view.trajectory
        view.frame = CGRect(x: UIScreen.main.bounds.width, y: 10 + CGFloat(trajectory * 30), width: view.bounds.width, height: view.bounds.height)
        view.startAnimation()
    }
}

