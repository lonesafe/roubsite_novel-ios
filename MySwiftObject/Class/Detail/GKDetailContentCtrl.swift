//
//  GKDetailContentCtrl.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2020/3/31.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
//? 和 ! 其实分别是Swift语言中对一种可选类型（ Optional) 操作的语法糖。
//？是一种判断后再拆包的语法糖
//！是一种强制拆包的语法糖
//当你不确定有值的时候就可以用 ?
//当你确定有值的时候可以用 !
class GKDetailContentCtrl: BaseViewController,VTMagicViewDelegate,VTMagicViewDataSource {

    class func vcWithBookId(bookId :String) -> Self{
        let vc : GKDetailContentCtrl = GKDetailContentCtrl.init()
        vc.bookId = bookId;
        return vc as! Self;
    }
    private lazy var listData : [String] = {
        return ["推荐","章节"]
    }()
    private lazy var centreCtrl: GKCenterController = {
        return GKCenterController.vcWithBookId(bookId:self.bookId!);
    }()
    private lazy var chapterCtrl : GKChapterController = {
        return GKChapterController.vcWithBookId(bookId: self.bookId!);
    }()
    private var bookId : String? = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI();
    }
    private func loadUI() {
        self.addChild(self.magicViewCtrl);
        self.view.addSubview(self.magicViewCtrl.view);
        self.magicViewCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.magicViewCtrl.magicView.reloadData();
    }
    private lazy var magicViewCtrl: VTMagicController = {
        let ctrl = VTMagicController.init();
        ctrl.magicView.navigationInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        ctrl.magicView.separatorHeight = 0.5;
        ctrl.magicView.backgroundColor = Appxffffff
        ctrl.magicView.separatorColor = UIColor.clear;
        ctrl.magicView.navigationColor = Appxffffff;
        ctrl.magicView.switchStyle = .default;
        
        ctrl.magicView.sliderColor = Appx000000
        ctrl.magicView.sliderExtension = 1;
        ctrl.magicView.bubbleRadius = 2.5;
        ctrl.magicView.sliderWidth = 0;
        
        ctrl.magicView.layoutStyle = .center;
        ctrl.magicView.navigationHeight = 40;
        ctrl.magicView.sliderHeight = 0.0;
        ctrl.magicView.itemSpacing = 30;
        
        ctrl.magicView.isAgainstStatusBar = false;
        ctrl.magicView.dataSource = self;
        ctrl.magicView.delegate = self;
        ctrl.magicView.itemScale = 1.15;
        ctrl.magicView.needPreloading = true;
        ctrl.magicView.bounces = false;
        return ctrl
    }()
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.listData;
    }
    func magicView(_ magicView: VTMagicView,menuItemAt: UInt) -> UIButton {
        let button = magicView.dequeueReusableItem(withIdentifier: "com.new.btn.itemIdentifier") ?? UIButton.init();
        button.setTitle(self.listData[Int(menuItemAt)], for: .normal);
        button.setTitleColor(Appx999999, for: .normal);
        button.setTitleColor(AppColor, for: .selected);
        button.titleLabel?.font = UIFont.systemFont(ofSize:15, weight: .regular);
        return button;
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        return pageIndex == 0  ? self.centreCtrl : self.chapterCtrl;
    }
}
