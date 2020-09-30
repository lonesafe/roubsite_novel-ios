//
//  GKSearchTopView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKSearchTopView: UIView {
    lazy var mainView : UIView  = {
        let mainView : UIView = UIView.init();
        mainView.backgroundColor = UIColor.white;
        return mainView;
    }()
    lazy var imageV : UIImageView  = {
        let imageV : UIImageView = UIImageView.init();
        imageV.image = UIImage.init(named: "ic_strategy_search")
        return imageV;
    }()
    lazy var backBtn : UIButton  = {
        let backBtn : UIButton = UIButton.init(type: .custom);
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        backBtn.setTitle("取消", for: .normal);
        backBtn.setTitleColor(UIColor.white, for: .normal);
        return backBtn;
    }()
    lazy var textField  : UITextField  = {
        let textField : UITextField = UITextField.init();
        textField.clearButtonMode = .whileEditing;
        textField.font = UIFont.systemFont(ofSize: 14);
        textField.placeholder = "作者/书名";
        textField.tintColor = AppColor;
        return textField;
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadUI();
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.loadUI();
    }
    func loadUI(){
        self.mainView.layer.masksToBounds = true;
        self.mainView.layer.cornerRadius  = 4;
        self.backgroundColor = AppColor;
        self.addSubview(self.mainView);
        self.addSubview(self.backBtn);
        self.backBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview();
            make.centerY.equalTo(self.mainView);
            make.bottom.equalToSuperview();
            make.height.equalTo(44)
            make.width.equalTo((60));
        }
        self.mainView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(15);
            make.height.equalTo(32);
            make.right.equalTo(self.backBtn.snp.left);
            make.centerY.equalTo(self.backBtn);
        }
        
        self.mainView.addSubview(self.imageV);
        self.imageV.snp_makeConstraints { (make) in
            make.width.equalTo(15);
            make.height.equalTo(14);
            make.left.equalToSuperview().offset(10);
            make.centerY.equalToSuperview();
        }
        self.mainView.addSubview(self.textField);
        self.textField.snp_makeConstraints { (make) in
            make.top.bottom.equalToSuperview();
            make.left.equalTo(self.imageV.snp_right).offset(10)
            make.right.equalToSuperview().offset(-10);
        }
        
    }

}
