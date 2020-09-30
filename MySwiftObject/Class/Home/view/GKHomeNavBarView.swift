//
//  GKHomeNavBarView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKHomeNavBarView: UIView {

    @IBOutlet weak var chirdenBtn: UIButton!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        self.mainView.layer.masksToBounds = true;
        self.mainView.layer.cornerRadius = 4.0;
        self.reloadUI();
    }
    func reloadUI(){
        let userModel :GKUserModel = GKUserManager.getModel();
        self.chirdenBtn.isSelected = (userModel.state == .GKUserBoy) ? false : true;
    }

}
