//
//  GKDetailTabView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKDetailTabView: UIView {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!

    override func awakeFromNib() {
        self.favBtn.setTitle("收藏", for: .normal);
        self.favBtn.setTitle("收藏", for: UIControl.State(rawValue: UIControl.State.normal.rawValue|UIControl.State.highlighted.rawValue));
        
        self.favBtn.setTitle("已收藏", for: .selected);
        self.favBtn.setTitle("已收藏", for: UIControl.State(rawValue: UIControl.State.selected.rawValue|UIControl.State.highlighted.rawValue));
    }
    deinit {
        
    }
}
