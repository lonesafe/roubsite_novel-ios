//
//  GKCenterController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2020/3/31.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON
import ATRefresh_Swift

class GKCenterController: BaseConnectionController {

    class func vcWithBookId(bookId: String) -> Self {
        let vc: GKCenterController = GKCenterController.init();
        vc.bookId = bookId
        return vc as! Self;
    }

    private lazy var listData: [GKBookModel] = {
        return []
    }()
    private lazy var titleLab: UILabel = {
        let label: UILabel = UILabel.init();
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2;
        label.textColor = Appx666666;
        return label
    }()
    private var bookId: String? = "";
    private let top: CGFloat = 10;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: ATRefreshOption(rawValue: ATRefreshOption.header.rawValue | ATRefreshOption.autoHeader.rawValue));
    }

    override func refreshData(page: Int) {
        if bookId!.count > 0 {
            RoubSiteNovelClassifyNet.bookCommend(bookId: self.bookId!, sucesss: { (object) in
                if ("1" == object["status"]) {
                    self.listData.removeAll();
                    let novelInfo: [JSON] = object["data"].arrayValue;
                    for item in novelInfo {
                        var data: GKBookModel = GKBookModel.init();
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
                        self.listData.append(data);
                    }
                }
                self.collectionView.reloadData();
                self.endRefresh(more: false)
            }) { (error) in
                self.endRefreshFailure();
            };
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.top;
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.top;
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.top, bottom: self.top, right: self.top);
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - self.top * 5) / 4.0;
        let height = width * 1.35 + 40;
        return CGSize.init(width: width, height: height);
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GKBookCell = GKBookCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        cell.model = self.listData[indexPath.row];
        return cell;
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: GKBookModel = self.listData[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId!);
    }

    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 200 / 2;
    }
}
