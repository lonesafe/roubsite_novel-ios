//
//  GKBookCaseController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBookCaseController: BaseConnectionController {
    private lazy var listBtn: UIButton = {
        let listBtn : UIButton = UIButton.init(type: .custom);
        listBtn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44);
        listBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10);
        listBtn.isSelected = false;
        listBtn.setImage(UIImage.init(named: "icon_list"), for: .normal);
        listBtn.setImage(UIImage.init(named: "icon_grid"), for: .selected);
        listBtn.addTarget(self, action: #selector(listAction(sender:)), for: .touchUpInside);
        return listBtn;
    }()
    private lazy var listData: [GKBookModel] = {
        return []
    }()
    private func listTable() -> Bool{
        return self.listBtn.isSelected;
    }
    private func top() -> CGFloat{
        return self.listTable() ? 0 : 15.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "我的书架")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.listBtn);
        self.setupEmpty(scrollView: self.collectionView)
        self.setupRefresh(scrollView: self.collectionView, options: .defaults)
    }
    @objc func listAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.refreshData(page: 1)
    }
    override func refreshData(page: Int) {
        GKBookCaseDataQueue.getBookModels(page: page, size: (20)) { (datas) in
            if page == 1{
                self.listData.removeAll()
            }
            self.listData.append(contentsOf:datas)
            self.collectionView.reloadData()
            if self.listData.count == 0{
                self.endRefreshFailure()
            }else{
                self.endRefresh(more: datas.count>=20);
            }
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.top()
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.top()
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top :CGFloat = self.top()
        return UIEdgeInsets(top: top, left: top, bottom: top, right: top)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.listTable() {
            let width :CGFloat = SCREEN_WIDTH
            let height :CGFloat = 140
            return CGSize.init(width: width, height: height)
        }
        let width = (SCREEN_WIDTH - 60)/3.0
        let height = width * 1.35 + 50
        return CGSize.init(width: width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.listTable() {
            let cell :GKBookTableCell = GKBookTableCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
            cell.model = self.listData[indexPath.row]
            return cell;
        }
        let cell : GKBookCell = GKBookCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:GKBookModel = self.listData[indexPath.row]
        GKJump.jumpToNovel(bookModel: model)
    }
}
