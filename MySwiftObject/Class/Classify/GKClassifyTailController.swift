//
//  GKClassifyTailController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKClassifyTailController: BaseTableViewController {
    convenience init(group:String,name:String) {
        self.init();
        self.group = group ;
        self.name = name ;
    }
    private lazy var listData: [GKBookModel] = {
        return []
    }()
    private var group :String!;
    private var name :String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: self.name)
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options:.defaults);
    }
    override func refreshData(page: Int) {
        GKClassifyNet.classifyTail(group: self.group, name: self.name, page: page, sucesss: { (respond) in
            if page == RefreshPageStart{
                self.listData.removeAll();
            }
            if let list : [JSON] = respond["books"].array{
                for obj in list{
                    if let model : GKBookModel = GKBookModel.deserialize(from: obj.rawString()){
                        self.listData.append(model);
                    }
                }
                self.tableView.reloadData();
                let more : Bool = list.count >= RefreshPageSize ? true : false;
                self.endRefresh(more: more);
            }
            print(respond);
        }) { (error) in
            self.endRefreshFailure();
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :GKClassifyTailCell = GKClassifyTailCell.cellForTableView(tableView:tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true);
        let model:GKBookModel = self.listData[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId ?? "");
    }

}
