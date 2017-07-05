
//
//  WHLandScapeMenuView.swift
//  DYZB
//
//  Created by Woodyhang on 2017/6/8.
//  Copyright © 2017年 小码哥. All rights reserved.
//

import UIKit

protocol WHLandScapeMenuViewDelegate:class  {
    func landScapeMenuViewDidClickedBackButton(landScapeView:WHLandScapeMenuView, setPortrait interfaceOrientation:UIInterfaceOrientation)

    func landScapeMenuViewdidClickedBarrageBtn(landScapeView:WHLandScapeMenuView,isOpenBarrage openBarrage:Bool)

}
class WHLandScapeMenuView: UIView {

    public weak var delegate:WHLandScapeMenuViewDelegate?

    fileprivate var manager:BarrageManager!

    /**弹幕发送操作者**/
    public var sendBarrage:(String) -> Swift.Void = {_ in }

    @IBOutlet weak var bottomControlView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    public var isShow:Bool = false {
        didSet {
            if isShow{
                for view in self.subviews{
                    view.isHidden = false
                }
            }else {
                for view in self.subviews{
                    view.isHidden = true
                }
            }
        }
    }

    @IBAction func barrageBtnClicked(_ sender: UIButton) {

        delegate?.landScapeMenuViewdidClickedBarrageBtn(landScapeView: self, isOpenBarrage: sender.isSelected)
        sender.isSelected = !sender.isSelected

    }
    @IBAction func backBtnCicked(_ sender: UIButton) {

        delegate?.landScapeMenuViewDidClickedBackButton(landScapeView: self, setPortrait: .portrait)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WHLandScapeMenuView.hideOrShowMenuView(_:))))

        /**监听键盘的弹入弹出**/
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillhide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    public static func landScapeMenuView() -> WHLandScapeMenuView{

        return Bundle.main.loadNibNamed("WHLandScapeMenuView", owner: nil, options: nil)?.first as! WHLandScapeMenuView
    }

    @objc private func hideOrShowMenuView(_ sender:UITapGestureRecognizer){
        if isShow{
            isShow = false
        }else {
            isShow = true
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WHLandScapeMenuView {

    @objc fileprivate func keyBoardWillShow(_ notif:Notification){
        let keyboaFrame = notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let duration = notif.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = keyboaFrame.size.height
            self.layoutIfNeeded()   
        }
    }

    @objc fileprivate func keyBoardWillhide(_ notif:Notification){

        let duration = notif.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 0
            self.layoutIfNeeded()

        }

    }
}

extension WHLandScapeMenuView:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        /**发送弹幕**/
        self.sendBarrage(textField.text!)
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
}
