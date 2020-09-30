//
//  GKNovelDirectoryView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
@objc protocol GKNovelDirectoryDelegate : NSObjectProtocol {
//    @objc optional func closeDirectoryView(view :GKNovelDirectoryView);
    @objc optional func selectChapter(view :GKNovelDirectoryView, chapter:NSInteger)
}
class GKNovelDirectoryView: UIView,UITableViewDataSource,UITableViewDelegate {
    var chapter:GKNovelChapter!;
    weak var delegate : GKNovelDirectoryDelegate!;
    lazy var listData : [GKNovelChapter] = {
        return []
    }()
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 60;
        tableView.keyboardDismissMode = .onDrag;
        tableView.separatorStyle = .none;
        tableView.showsVerticalScrollIndicator = false;
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()))
        tableView.backgroundColor = Appxf8f8f8;
        tableView.backgroundView?.backgroundColor = Appxf8f8f8;
        return tableView;
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.contentInset = UIEdgeInsets.init(top:STATUS_BAR_HIGHT, left: 0, bottom: 0, right: 0)
        self.loadUI();
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:  aDecoder);
        self.loadUI();
    }
    func setDatas(listData:[GKNovelChapter]){
        self.listData.removeAll();
        self.listData.append(contentsOf: listData);
        self.tableView.reloadData();
    }
    func loadUI(){
        self.isUserInteractionEnabled = true;
        self.addSubview(self.tableView);
        self.tableView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview();
            make.width.equalTo(SCREEN_WIDTH/5*4.0);
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  : GKNovelDirectoryCell = GKNovelDirectoryCell.cellForTableView(tableView: tableView, indexPath: indexPath)
        cell.selectionStyle = .none;
        let model : GKNovelChapter = self.listData[indexPath.row];
        if self.chapter != nil {
            cell.select = model.chapterId  == self.chapter.chapterId;
        }
        cell.imageLock.isHidden = !model.isVip;
        cell.titleLab.text = model.title;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if let myDelegate = self.delegate {
            myDelegate.selectChapter?(view: self, chapter: indexPath.row);
        }
    }
}
