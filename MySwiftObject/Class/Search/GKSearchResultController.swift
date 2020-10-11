//
//  GKSearchResultController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKSearchResultController: BaseTableViewController {
    convenience init(keyWord: String) {
        self.init()
        self.keyWord = keyWord
    }

    private var keyWord: String = ""
    private lazy var listData: [GKBookModel] = {
        return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: self.keyWord)
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }

    override func refreshData(page: Int) {
        RoubSiteNovelClassifyNet.bookSearch(hotWord: self.keyWord, page: page, size: RefreshPageSize, sucesss: { (object) in
            if page == 1 {
                self.listData.removeAll();
            }
            if ("1" == object["status"]) {
                print(object)
                var bookInfoData:JSON = object["data"];
                print(bookInfoData)
                var bookInfoList = bookInfoData["data"].arrayValue;
                for item in bookInfoList {
                    let data: GKBookModel = GKBookModel.init();
                    data.title = item["NOVEL_NAME"].stringValue;
                    data.bookId = item["NOVEL_ID"].stringValue;
                    data.author = item["AUTHOR_NAME"].stringValue;
                    data.cover = item["NOVEL_IMAGE"].stringValue;
                    data.lastChapter = item["LAST_CHAPTER_NAME"].stringValue;
                    data.shortIntro = item["NOVEL_SUMMARY"].stringValue;
                    if ("1" == item["IS_VIP"].stringValue) {
                        data.vip = true;
                    }
                    var updateTime = Int(item["LAST_UPDATE_TIME"].stringValue)!;
                    data.updateTime = TimeInterval.init(updateTime);
                    data.size = item["SIZE"].intValue;
                    self.listData.append(data);
                }
                self.tableView.reloadData();
                self.endRefresh(more: bookInfoList.count >= RefreshPageSize);
            } else {
                self.endRefreshFailure();
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
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GKClassifyTailCell = GKClassifyTailCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: GKBookModel = self.listData[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId!);

    }
}
