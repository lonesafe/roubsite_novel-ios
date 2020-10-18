//
//  GKItemViewController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKNovelItemController: BaseViewController {
    var chapter :NSInteger = 0
    var pageIndex:NSInteger = 0
    var content:GKNovelContent!
    var emptyData : Bool = false
    lazy var tryButton : UIButton = {
        var button : UIButton = UIButton.init()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 18
        button.setBackgroundImage(UIImage.imageWithColor(color: AppColor), for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(Appxffffff, for: .normal)
        button.setTitle("点击重试", for: .normal)
        button.isHidden = true
        return button;
    }()
    private lazy var titleLab: UILabel = {
        var label :UILabel = UILabel.init();
        label.textColor = UIColor.init(hex: "999999");
        label.font = UIFont.systemFont(ofSize:12);
        return label
    }()
    private lazy var subTitleLab: UILabel = {
        var subTitleLab :UILabel = UILabel.init();
        subTitleLab.textColor = UIColor.init(hex: "999999");
        subTitleLab.font = UIFont.systemFont(ofSize: 12);
        subTitleLab.textAlignment = .right;
        return subTitleLab
    }()
    private lazy var loadLab: UILabel = {
        var label : UILabel = UILabel.init();
        label.font  = UIFont.systemFont(ofSize: 18);
        label.textColor = Appx999999;
        label.textAlignment = .center;
        label.text = "数据加载中...";
        return label;
    }()
    private lazy var readView: GKNovelView = {
        var readView = GKNovelView.init(frame: BaseMacro.init().AppFrame)
        readView.backgroundColor = UIColor.clear;
        return readView
    }()
    private lazy var mainView: UIImageView = {
        let mainView : UIImageView = UIImageView.init();
        return mainView;
    }()
    func emptyData(empty : Bool){
        self.emptyData = true;
        self.loadLab.text = "数据空空如也.."
        self.tryButton.isHidden = true;
    }
    func setModel(model:GKNovelContent, chapter:NSInteger, pageIndex:NSInteger){
        self.content = model;
        self.pageIndex = pageIndex;
        self.chapter = chapter;
        self.readView.content = model.attContent(page: pageIndex)
        self.titleLab.text = model.title;
        self.subTitleLab.text = String(pageIndex+1) + "/" + String(model.pageCount);
        let res : Bool = self.readView.content.string.count == 0 ? false : true
        self.tryButton.isHidden = res
        self.loadLab.isHidden = res
        self.loadLab.text = "数据加载失败..."
    }
    private func setThemeUI(){
        self.mainView.image = GKNovelSetManager.defaultSkin();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mainView);
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.view.addSubview(self.readView);
        self.view.addSubview(self.titleLab);
        self.view.addSubview(self.subTitleLab);
        self.view.addSubview(self.loadLab);
        self.view.addSubview(self.tryButton);
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(BaseMacro.init().STATUS_BAR_HIGHT - 5);
            make.left.equalTo(20);
        }
        self.subTitleLab.snp.makeConstraints { (make) in
            make.right.equalTo(-20);
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.titleLab.snp.right).offset(-20);
        }
        self.loadLab.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview();
        }
        self.tryButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self.loadLab.snp.bottom).offset(20);
            make.width.equalTo(120);
            make.height.equalTo(36);
            
        }
        self.setThemeUI();
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.readView.frame = BaseMacro.init().AppFrame;
    }
    
}
