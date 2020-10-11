//
//  GKNovelNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoubSiteNovelNet: NSObject {
    class func bookChapters(bookId: String, sucesss: @escaping ((_ object: GKNovelChapterInfo) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        let params: Dictionary = ["novelId": bookId];
        let url: String = "novel/GetChapterList";
        BaseNetManager.iGetUrlString(urlString: BaseNetManager.hostUrl(txcode: url), parameters: params, sucesss: { (object) in
            if ("1" == object["status"]) {
                let info: GKNovelChapterInfo = GKNovelChapterInfo.init();
                let chapterListInfo: [JSON] = object["data"].arrayValue;
                var chapters: [GKNovelChapter] = [];
                for item in chapterListInfo {
                    let chapter = GKNovelChapter.init();
                    chapter.bookId = bookId;
                    chapter.title = item["CHAPTER_NAME"].stringValue;
                    chapter.chapterId = item["CHAPTER_ID"].stringValue;
                    if (item["IS_VIP"].stringValue == "1") {
                        chapter.isVip = true;
                    } else {
                        chapter.isVip = false;
                    }
                    chapter.order = item["CHAPTER_ORDER"].intValue;
                    chapter.time = item["UPDATE_TIME"].stringValue;
                    chapters.append(chapter);
                }

                info._id = bookId;
                info.book = "";
                info.chapters = chapters;
                sucesss(info);
            } else {
                failure("error");
            }
        }, failure: failure);
    };

    class func bookContent(novelId: String, chapterId: String, sucesss: @escaping ((_ object: GKNovelContent) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        let params: Dictionary = ["novelId": novelId, "chapterId": chapterId];
        let url: String = "novel/GetChapterContent";
        BaseNetManager.iGetUrlString(urlString: BaseNetManager.hostUrl(txcode: url), parameters: params, sucesss: { (object) in
            let model: GKNovelContent = GKNovelContent.init()
            if (object["status"] == "1") {
                let chapterInfo: JSON = object["data"];
                model.bookId = novelId;
                if (chapterInfo["IS_VIP"].stringValue == "1") {
                    model.isVip = true;
                } else {
                    model.isVip = false;
                }
                model.chapterId = chapterId;
                model.title = chapterInfo["title"].stringValue;
                var content = chapterInfo["content"].stringValue;
                content = content.replacingOccurrences(of: "&nbsp;", with: "");
                content = content.replacingOccurrences(of: "<br>", with: "\r\n");
                content = content.replacingOccurrences(of: "<br />", with: "\r\n");
                model.content = content;
                sucesss(model);
            } else {
                failure("error");
            }
        }, failure: failure)

    };

    class func bookContentModel(bookId: String, model: GKNovelChapter, sucesss: @escaping ((_ object: GKNovelContent) -> Void), failure: @escaping ((_ error: String) -> Void)) {
        GKBookCacheDataQueue.getContentFromDataBase(bookId: bookId, chapterId: model.chapterId) { (content) in
            if content.content.count > 0 {
                sucesss(content);
            } else {
                RoubSiteNovelNet.bookContent(novelId: bookId, chapterId: model.chapterId, sucesss: { (content) in
                    content.bookId = model.bookId;
                    sucesss(content);
                    if content.content.count > 0 && content.bookId.count > 0 {
                        GKBookCacheDataQueue.insertContentToDataBase(bookId: bookId, content: content, completion: { (success) in

                        })
                    }
                }, failure: failure);
            }
        };
    }
}
