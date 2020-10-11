//
//  GKHomeNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RoubSiteNovelLoadOptions: OptionSet {
    public var rawValue: UInt

    static var None: RoubSiteNovelLoadOptions {
        return RoubSiteNovelLoadOptions(rawValue: 0)
    }
    static var DataNet: RoubSiteNovelLoadOptions {
        return RoubSiteNovelLoadOptions(rawValue: 1 << 1)
    };
    static var Database: RoubSiteNovelLoadOptions {
        return RoubSiteNovelLoadOptions(rawValue: 1 << 2)
    };
    static var Default: RoubSiteNovelLoadOptions {
        return RoubSiteNovelLoadOptions(rawValue: DataNet.rawValue | Database.rawValue)
    }
}

private let netManager = RoubSiteBlockNet();

class RoubSiteBlockNet: NSObject {
    private var completion: ((_ options: RoubSiteNovelLoadOptions) -> Void)!;
    private lazy var listData: [GKHomeInfo] = {
        return []
    }()
    private lazy var arrayData: [GKHomeInfo] = {
        return []
    }()
    private var bookCase: GKHomeInfo!;
    static let manager = RoubSiteBlockNet();

    func homeNet(options: RoubSiteNovelLoadOptions, sucesss: @escaping ((_ datas: [GKHomeInfo]) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        let group: DispatchGroup = DispatchGroup.init();
        var value = options.rawValue & RoubSiteNovelLoadOptions.DataNet.rawValue;
        let userData: GKUserModel = GKUserManager.getModel();
        if value == 2 {
            self.arrayData.removeAll();
            if userData.rankDatas.count > 0 {
                for obj in userData.rankDatas {
                    let model: RoubSiteNovelBlockInfo = obj as RoubSiteNovelBlockInfo;
                    group.enter();
                    RoubSiteBlockNet.getBlockNovelInfo(blockId: model.blockId, sucesss: { (object) in
                        if ("1" == object["status"].stringValue) {
                            var novelList: [GKBookModel] = [];
                            let data: [JSON] = object["data"].arrayValue
                            for item in data {
                                let novel: GKBookModel = GKBookModel.init();
                                novel.size = item["SIZE"].intValue;
                                if ("1" == item["IS_VIP"].stringValue) {
                                    novel.vip = true;
                                }
                                var updateTime = Int(item["LAST_UPDATE_TIME"].stringValue)!;
                                novel.updateTime = TimeInterval.init(updateTime);
                                novel.title = item["NOVEL_NAME"].stringValue;
                                novel.shortIntro = item["NOVEL_SUMMARY"].stringValue;
                                novel.lastChapter = item["LAST_CHAPTER_NAME"].stringValue;
                                novel.cover = item["NOVEL_IMAGE"].stringValue;
                                novel.bookId = item["NOVEL_ID"].stringValue;
                                novel.author = item["AUTHOR_NAME"].stringValue;
                                novelList.append(novel);
                            }
                            var info: GKHomeInfo = GKHomeInfo.init();
                            info.title = model.title;
                            info.shortTitle = model.shortTitle;
                            info.homeId = model.blockId;
                            info.books = novelList;
                            if info.books.count > 0 {
                                info.state = GKHomeInfoState.DataNet
                                self.arrayData.append(info);
                            }
                        }
                        group.leave()
                    }) { (error) in
                        group.leave()
                    }
                }
            }
        }
        value = options.rawValue & RoubSiteNovelLoadOptions.Database.rawValue;
        if value == 4 {
            group.enter();
            GKBookCaseDataQueue.getBookModels { (datas) in
                if datas.count > 0 {
                    let info: GKHomeInfo = GKHomeInfo();
                    info.state = GKHomeInfoState.Database
                    info.books = datas
                    info.title = "我的书架"
                    info.shortTitle = "我的书架"
                    self.bookCase = info;
                } else {
                    self.bookCase = nil;
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.listData.removeAll();
            if self.bookCase != nil {
                self.listData.append(self.bookCase);
            }
            if self.arrayData.count > 0 {
                self.listData.append(contentsOf: self.arrayData);
            }
            if self.listData.count > 0 {
                sucesss(self.listData);
            } else {
                failure("数据空空如也");
            }
        }
    }

    class func getBlockNovelInfo(blockId: String, sucesss: @escaping ((_ object: JSON) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        let url = "block/getBlockNovelInfo";
        BaseNetManager.baseCodeUrl(urlString: BaseNetManager.hostUrl(txcode: url), method: .get, parameters: ["blockId": blockId], sucesss: sucesss, failure: failure);
    }

    class func getAllBlocks(sucesss: @escaping ((_ object: JSON) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        BaseNetManager.baseCodeUrl(urlString: BaseNetManager.hostUrl(txcode: "block"), method: .get, parameters: [:], sucesss: sucesss, failure: failure);
    }

    class func reloadHomeData(options: RoubSiteNovelLoadOptions) {
        if RoubSiteBlockNet.manager.completion != nil {
            RoubSiteBlockNet.manager.completion(options);
        }
    }

    class func reloadHomeDataNeed(completion: @escaping ((_ options: RoubSiteNovelLoadOptions) -> Void)) {
        RoubSiteBlockNet.manager.completion = completion;
    }
}
