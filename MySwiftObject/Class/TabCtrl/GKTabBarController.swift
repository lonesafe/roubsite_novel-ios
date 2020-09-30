//
//  GKTabBarController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKTabBarController: UITabBarController {
    private lazy var listData: [UIViewController] = {
        return [];
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false;
        let vc = GKHomeController.init();
        self.createCtrl(vc: vc, title:"首页", normal:"icon_tabbar_home_n", select:"icon_tabbar_home_h");
        let classCtrl = GKClassifyController.init();
        self.createCtrl(vc: classCtrl, title:"分类", normal:"icon_tabbar_found_n", select:"icon_tabbar_found_h");
        let bookCaseCtrl = GKBookCaseController.init();
        self.createCtrl(vc: bookCaseCtrl, title:"书架", normal:"icon_tabbar_video_n", select:"icon_tabbar_video_h");
        let mine = GKMineController.init();
        self.createCtrl(vc: mine, title:"我的", normal:"icon_tabbar_wall_n", select:"icon_tabbar_wall_h");
        
        self.viewControllers = self.listData;
        
    }
    private func createCtrl(vc :UIViewController,title :String,normal: String,select :String) {
        let nv = BaseNavigationController.init(rootViewController: vc);
        vc.showNavTitle(title: title)
        nv.tabBarItem.title = title;
        nv.tabBarItem.image = UIImage.init(named: normal)?.withRenderingMode(.alwaysOriginal);
        nv.tabBarItem.selectedImage = UIImage.init(named: select)?.withRenderingMode(.alwaysOriginal);
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : AppColor as Any], for: .selected);
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Appx999999 as Any], for: .normal);
        self.listData.append(nv);
    }

}
