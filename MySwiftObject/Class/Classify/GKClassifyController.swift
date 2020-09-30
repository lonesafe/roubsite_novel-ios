//
//  GKClassifyController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKClassifyController: BaseViewController,VTMagicViewDelegate,VTMagicViewDataSource {
    private var listData:[String]=[];
    private var listTitles:[String]=[];
    private lazy var magicViewCtrl: VTMagicController = {
        let ctrl = VTMagicController.init();
        ctrl.magicView.navigationInset = UIEdgeInsets(top: STATUS_BAR_HIGHT, left: 10, bottom: 0, right: 10);
        ctrl.magicView.separatorHeight = 0.5;
        ctrl.magicView.backgroundColor = Appxffffff
        ctrl.magicView.separatorColor = UIColor.clear;
        ctrl.magicView.navigationColor = Appxffffff;
        ctrl.magicView.switchStyle = .default;
        
        ctrl.magicView.sliderColor = AppColor
        ctrl.magicView.sliderExtension = 1;
        ctrl.magicView.bubbleRadius = 1;
        ctrl.magicView.sliderWidth = 30;
        
        ctrl.magicView.layoutStyle = .default;
        ctrl.magicView.navigationHeight = NAVI_BAR_HIGHT;
        ctrl.magicView.sliderHeight = 2;
        ctrl.magicView.itemSpacing = 20;
        
        ctrl.magicView.isAgainstStatusBar = false;
        ctrl.magicView.dataSource = self;
        ctrl.magicView.delegate = self;
        ctrl.magicView.itemScale = 1.15;
        ctrl.magicView.needPreloading = true;
        ctrl.magicView.bounces = false;
        return ctrl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.loadData();
        self.loadUI();
        // Do any additional setup after loading the view.
    }
    private func loadData(){
        GKClassifyNet.getBigSort(sucesss: { (object) in
            if object["status"] == "1"{
                let list:[JSON] = object["data"].arrayValue;
                for srotInfo in list {
                    self.listData.append(srotInfo["SORT_ID"].stringValue);
                    self.listTitles.append(srotInfo["SORT_NAME"].stringValue);
                }
                self.magicViewCtrl.magicView.reloadData();
            }else{
                
            }
            
        }) { (error) in
            
        };
    }
    private func loadUI() {
        self.fd_prefersNavigationBarHidden = true;
        self.addChild(self.magicViewCtrl);
        self.view.addSubview(self.magicViewCtrl.view);
        self.magicViewCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.magicViewCtrl.magicView.reloadData();
    }
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.listTitles;
    }
    func magicView(_ magicView: VTMagicView,menuItemAt: UInt) -> UIButton {
        let button : UIButton = magicView.dequeueReusableItem(withIdentifier: "com.new.btn.itemIdentifier") ?? UIButton.init();
        button.setTitle(self.listTitles[Int(menuItemAt)], for: .normal);
        button.setTitleColor(Appx333333, for: .normal);
        button.setTitleColor(AppColor, for: .selected);
        button.titleLabel?.font = UIFont.systemFont(ofSize:16, weight: .regular);
        return button;
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let vc = (magicView.dequeueReusablePage(withIdentifier: "com.new.btn.itemIdentifier")) ?? GKClassifyItemController()
        let ctrl :GKClassifyItemController = vc as! GKClassifyItemController
        ctrl.titleName = self.listData[Int(pageIndex)]
        return vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default;
    }
   
}
