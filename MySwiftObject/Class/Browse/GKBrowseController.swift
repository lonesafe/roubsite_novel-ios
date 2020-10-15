//
//  GKBrowseController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBrowseController: BaseTableViewController {
    private lazy var listData : [GKBrowseModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title:"浏览历史")
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        GKBrowseDataQueue.getBookModel(page: page, size: (20)) { (object) in
            if page == 1{
                self.listData.removeAll();
            }
            self.listData.append(contentsOf: object);
            self.tableView.reloadData();
            if self.listData.count == 0{
                self.endRefreshFailure();
            }else{
                self.endRefresh(more: object.count >= 20);
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SortBookListItem = SortBookListItem.cellForTableView(tableView: tableView, indexPath: indexPath)
        let model :GKBrowseModel = self.listData[indexPath.row];
        let time :String = GKNumber.getTime(timeStamp: model.updateTime);
        cell.model = model.bookModel;
        cell.subTitleLab.text = "上次阅读到 : 第"+String(model.chapter!+1)+"章,第"+String(model.pageIndex!+1)+"页" + " \n\n上次阅读时间 : " + time;
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model :GKBrowseModel = self.listData[indexPath.row];
        GKJump.jumpToNovel(bookModel: model.bookModel);
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row :UITableViewRowAction = UITableViewRowAction.init(style: .default, title: "删除") { (row, index) in
            self.deleteAction(indexPath: indexPath);
        };
        return [row];
    }
    func deleteAction(indexPath:IndexPath){
        ATAlertView.showAlertView(title: "确定删除该记录", message:"", normals:["取消"], hights: ["确定"]) { (title , index) in
            if index > 0{
                let model :GKBrowseModel = self.listData[indexPath.row];
                GKBrowseDataQueue.deleteBookModel(bookId: model.bookId!, completion: { (success) in
                    if success{
                        if self.listData.count > indexPath.row{
                            self.listData.remove(at: indexPath.row)
                            self.tableView.reloadData();
                        }
                    }
                })
            }
        }
    }

}
