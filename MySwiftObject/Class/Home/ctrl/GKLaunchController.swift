//
//  GKLaunchController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Lottie

class GKLaunchController: BaseViewController {

    private var timer: Timer!;
    lazy var lottieView : AnimationView = {
        return AnimationView(name: "Launch")
    }()
    @IBOutlet weak var skipBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        self.skipBtn.layer.masksToBounds = true
        self.skipBtn.layer.masksToBounds = true
        self.skipBtn.layer.cornerRadius = 5
        self.skipBtn.layer.borderWidth = 1
        self.skipBtn.layer.borderColor = Appxf8f8f8.cgColor
        self.skipBtn.backgroundColor = Appx999999
        self.skipBtn.addTarget(self, action:#selector(skipAction), for: .touchUpInside)
        self.skipBtn.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        self.skipBtn.setTitleColor(UIColor.white, for: .normal)
        self.startTimer()
        self.view.addSubview(self.lottieView)
        self.lottieView.snp.makeConstraints { (make) in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
        self.lottieView.play { (finish) in
            self.dismissController()
        }
    }
    private func startTimer(){
        var time : Int = 5 - 1
        weak var mySelf = self
        self.skipBtn.setTitle(String(time)+"S跳过", for: .normal);
        self.timer = Timer.init(timeInterval: 1, repeats: true, block: { (timer) in
            if time < 1{
                self.skipAction()
                return
            }
            time = time - 1
            mySelf?.skipBtn.setTitle(String(time)+"S跳过", for: .normal)
        });
        RunLoop.current.add(self.timer, forMode: .common)
    }
    private func stopTimer(){
        if self.timer != nil {
            if self.timer.isValid {
                self.timer.invalidate()
            }
        }
    }
    private func dismissController(){
        UIView.animate(withDuration: 0.35, delay: 0.3, options: .curveEaseOut, animations: {
            self.view.alpha = 0.0;
        }) { (success) in
            self.back(animated: false)
        }
    }
    @objc private func skipAction(){
        self.stopTimer();
        self.dismissController();
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    override var prefersStatusBarHidden: Bool{
        return false
    }

}
