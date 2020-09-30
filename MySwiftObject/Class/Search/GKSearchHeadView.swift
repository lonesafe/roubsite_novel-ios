//
//  GKSearchHeadView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKSearchHeadView: UIView {
    
    lazy var titleLab : UILabel = {
        let label : UILabel = UILabel.init();
        label.textColor = Appx333333;
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold);
        return label;
    }()
    lazy var deleteBtn : UIButton = {
        let deleteBtn : UIButton = UIButton.init(type: .custom);
        deleteBtn.setImage(UIImage.init(named: "icon_delete"), for: .normal);
        return deleteBtn;
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        loadUI();
    }
    func loadUI(){
        self.addSubview(self.titleLab);
        self.addSubview(self.deleteBtn);
        self.titleLab.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(15);
            make.centerY.equalToSuperview();
        }
        self.deleteBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15);
            make.centerY.equalToSuperview();
        }
        let lineView : UIView = UIView.init();
        lineView.backgroundColor = Appxdddddd;
        self.addSubview(lineView);
        lineView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.height.equalTo(0.5);
        }
    }
}
