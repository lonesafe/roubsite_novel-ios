//
//  GKSexViewController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKSexViewController: BaseConnectionController {
    convenience init(completion :(()-> Void)? = nil) {
        self.init();
        self.completion = completion;
    }
    private var info:GKRankInfo!;
    private var state :GKUserState = .GKUserBoy;
    private lazy var listData: [GKRankModel] = {
        return []
    }()
    private lazy var selectData: [GKRankModel] = {
        return []
    }()
    private var completion :(() ->Void)? = nil;
    private lazy var titleLab : UILabel = {
        let label :UILabel = UILabel.init();
        label.textAlignment = .center;
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold);
        label.textColor = AppColor;
        return label;
    }()
    private lazy var boyBtn: UIButton = {
        let boyBtn : UIButton = UIButton.init(type: .custom);
        boyBtn .setImage(UIImage.init(named: "icon_boy"), for: .normal);
        boyBtn.addTarget(self, action: #selector(boyAction), for: .touchUpInside);
        return boyBtn;
    }()
    
    private lazy var girlBtn : UIButton = {
        let girlBtn : UIButton = UIButton.init(type: .custom);
        girlBtn .setImage(UIImage.init(named: "icon_woman"), for: .normal);
        girlBtn.addTarget(self, action: #selector(girlAction), for: .touchUpInside);
        return girlBtn;
    }()
    private lazy var sureBtn : UIButton = {
        let sureBtn : UIButton = UIButton.init(type: .custom);
        sureBtn.setTitle("确定", for:.normal);
        sureBtn.backgroundColor = AppColor;
        sureBtn.layer.masksToBounds = true;
        sureBtn.layer.cornerRadius = 5;
        sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside);
        return sureBtn;
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad();
        self.loadUI();
        self.loadData();
    }
    private func loadUI(){
        self.collectionView.backgroundView?.backgroundColor = Appxffffff;
        self.collectionView.backgroundColor = Appxffffff;
        self.showNavTitle(title: "选择性别")
        self.view.addSubview(self.titleLab);
        self.titleLab.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalToSuperview().offset(20 + STATUS_BAR_HIGHT);
        }
        self.view.addSubview(self.boyBtn);
        self.view.addSubview(self.girlBtn);
        self.boyBtn.snp_makeConstraints { (make) in
            make.width.height.equalTo(120);
            make.top.equalTo(self.titleLab.snp_bottom).offset(15);
            make.right.equalTo(self.view.snp_centerX).offset(-25);
        }
        self.girlBtn.snp_makeConstraints { (make) in
            make.width.height.equalTo(120);
            make.left.equalTo(self.boyBtn.snp_right).offset(50);
            make.centerY.equalTo(self.boyBtn.snp_centerY);
        }
        self.view.addSubview(self.sureBtn);
        self.sureBtn.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset((-TAB_BAR_ADDING - 20));
            make.height.equalTo(44);
            make.left.equalToSuperview().offset(20);
            make.right.equalToSuperview().offset(-20);
        }
        self.collectionView.snp_remakeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalTo(self.boyBtn.snp_bottom).offset(10);
            make.bottom.equalTo(self.sureBtn.snp_top);
        }
        self.collectionView.bounces = false;
        self.boyAction();
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .defaults);
    }
    private func loadData(){
        let info:GKUserModel = GKUserManager.getModel();
        self.state = info.state
        
        if self.state == .GKUserBoy {
            self.boyAction();
        }else{
            self.girlAction();
        }
    }
    override func refreshData(page: Int) {
        GKHomeNet.homeSex(sucesss: { (object) in
            if let info : GKRankInfo = GKRankInfo.deserialize(from: object.rawString()){
                self.info = info;
                self.listData = (self.state == .GKUserBoy ? self.info.male : self.info.female)!;
                self.collectionView.reloadData();
                self.endRefresh(more: false);
            }else{
                self.endRefreshFailure();
            }
        }) { (error) in
            self.endRefreshFailure();
        }
    }
    @objc private func sureAction(){
        if self.selectData.count == 0 {
            MBProgressHUD.showMessage("选择一项做为首页数据吧");
            return;
        }
        let vc : GKUserModel = GKUserModel();
        vc.state = self.state;
        vc.rankDatas = self.selectData;
        GKUserManager.saveModel(model: vc);
        if completion != nil {
            completion!()
        }else{
            GKHomeNet.reloadHomeData(options:.DataNet);
            self.goBack();
        }
    }
    @objc private func boyAction(){
        self.titleLab.text = "我是男生";
        self.state = .GKUserBoy;
        self.selectAction(sender: self.boyBtn)
        self.normalAction(sender: self.girlBtn)
        if (self.info != nil) {
            self.listData = self.info.male! ;
            self.collectionView.reloadData();
            self.selectData.removeAll();
        }
    }
    @objc private func girlAction(){
        self.titleLab.text = "我是女生";
        self.state = .GKUserGirl;
        self.normalAction(sender: self.boyBtn)
        self.selectAction(sender: self.girlBtn)
        if (self.info != nil) {
            self.listData = self.info.female!;
            self.collectionView.reloadData();
            self.selectData.removeAll();
        }
    }
    
    @objc override func goBack() {
        self.back(animated: false)
    }
    private func selectAction(sender : UIButton){
        sender.layer.masksToBounds = true;
        sender.layer.cornerRadius = 5;
        sender.layer.borderWidth = 3;
        sender.layer.borderColor = AppColor.cgColor;
    }
    private func normalAction(sender:UIButton){
        sender.layer.masksToBounds = true;
        sender.layer.cornerRadius = 0;
        sender.layer.borderWidth = 0;
        sender.layer.borderColor = UIColor.init(hex: "ffffff").cgColor;
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 60)/3.0;
        let height :CGFloat = 34;
        return CGSize.init(width: width, height: height);
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :GKSexCell = GKSexCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        let info :GKRankModel = self.listData[indexPath.row];
        cell.model = info;
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info :GKRankModel = self.listData[indexPath.row];
        info.select = !info.select!;
        let content = self.selectData.contains { (model) -> Bool in
            return model.rankId == info.rankId;
        }
        if content{
            if self.selectData.count > indexPath.row{
                self.selectData.remove(at:indexPath.row);
            }
        }else{
            self.selectData.append(info);
        }
        collectionView.reloadData();
        
    }
}
