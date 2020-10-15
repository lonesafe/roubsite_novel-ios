//
//  SortBookListController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class SortBookListController: BaseTableViewController {
    convenience init(sortId: String, name: String) {
        self.init();
        self.sortId = sortId;
        self.name = name;
    }

    private lazy var listData: [GKBookModel] = {
        return []
    }()
    private var sortId: String!;
    private var name: String!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: self.name)
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }

    override func refreshData(page: Int) {
        RoubSiteNovelClassifyNet.classifyTail(sortId: self.sortId, type: "CREATE_TIME", page: page, sucesss: { (respond) in
            if page == RefreshPageStart {
                self.listData.removeAll();
            }
            if respond["status"] == "1" {
                if let list: [JSON] = respond["data"].array {
                    for obj in list {
                        let model: GKBookModel = GKBookModel.init();
                        model.author = obj["AUTHOR_NAME"].stringValue;
                        model.bookId = obj["NOVEL_ID"].stringValue;
                        model.cover = obj["NOVEL_IMAGE"].stringValue;
                        model.lastChapter = obj["LAST_CHAPTER_NAME"].stringValue;
                        model.shortIntro = String(obj["NOVEL_SUMMARY"].stringValue);
                        model.title = obj["NOVEL_NAME"].stringValue;
                        model.size = Int(obj["SIZE"].intValue);
                        var updateTime = Int(obj["LAST_UPDATE_TIME"].stringValue)!;
                        model.updateTime = TimeInterval.init(updateTime);
                        if ("1" == obj["IS_VIP"]) {
                            model.vip = true;
                        }
                        self.listData.append(model);
                    }
                    self.tableView.reloadData();
                    let more: Bool = list.count >= RefreshPageSize ? true : false;
                    self.endRefresh(more: more);
                }
            }
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
        let cell: SortBookListItem = SortBookListItem.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model: GKBookModel = self.listData[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId ?? "");
    }

}
