//
//  GKChapterController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2020/3/31.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class GKChapterController: BaseTableViewController {
    class func vcWithBookId(bookId : String) -> Self{
        let vc :GKChapterController = GKChapterController.init();
        vc.bookId = bookId;
        return vc as! Self;
    }
    private var bookId : String? = "";
    private var info : GKNovelChapterInfo = GKNovelChapterInfo();
    private var source : GKNovelSource = GKNovelSource();
    private var bookModel : GKBookModel = GKBookModel();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        if self.bookId!.count > 0 {
            GKNovelNet.bookSummary(bookId: self.bookId!, sucesss: { (source : GKNovelSource) in
                self.source = source;
                GKNovelNet.bookChapters(bookId: source.sourceId!, sucesss: { (info) in
                    self.info = info;
                    self.tableView.reloadData();
                    self.endRefresh(more:false);
                }) { (error) in
                    self.endRefreshFailure();
                }
            }) { (error) in
                self.endRefreshFailure();
            }
            GKClassifyNet.bookDetail(bookId: self.bookId!, sucesss: { (object) in
                if let model : GKBookModel = GKBookModel.deserialize(from: object.rawString()){
                    self.bookModel = model;
                }
            }) { (error) in

            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.info.chapters.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GKNovelDirectoryCell = GKNovelDirectoryCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.selectionStyle = .none;
        let model : GKNovelChapter = self.info.chapters[indexPath.row];
        cell.imageLock.isHidden = !model.isVip;
        cell.titleLab.text = model.title;
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.inseDataQueue(sender: self.info.chapters[indexPath.row], chapter: indexPath.row)
    }
    func inseDataQueue(sender:GKNovelChapter,chapter : NSInteger){
        let model:GKBrowseModel = GKBrowseModel.init();
        model.bookId = self.bookId;
        model.chapter = chapter;
        model.pageIndex = 0;
        model.chapterInfo = self.info;
        model.source = self.source;
        GKBrowseDataQueue.insertBookModel(browse: model) { (success) in
            let bookModel : GKBookModel = self.bookModel
            bookModel.bookId = self.bookId;
            GKJump.jumpToNovel(bookModel:bookModel)
        }
    }
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 200/2;
    }
}
