//
//  GKNovelNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKNovelNet: NSObject {
    class func bookSummary(bookId:String,sucesss:@escaping ((_ source : GKNovelSource) ->Void),failure:@escaping ((_ error : String) ->Void)){
        BaseNetManager.iGetUrlString(urlString: BaseNetManager.hostUrl(txcode:"toc"), parameters: ["book":bookId,"view":"summary"], sucesss: { (object) in
            if let data = [GKNovelSource].deserialize(from: object.rawString()){
                let list : [GKNovelSource] = data as! [GKNovelSource];
                if list.count > 0 {
                    sucesss(list.first!);
                }else{
                    failure("");
                }
            }else{
                failure("");
            }
//            }
        }, failure: failure);
    };
    class func bookChapters(bookId:String,sucesss:@escaping ((_ object : GKNovelChapterInfo) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url :String = "toc/" + String(bookId);
//        BaseNetManager.iGetUrlString(urlString: BaseNetManager.hostUrl(txcode:url), parameters: ["view":"chapters"], sucesss: { (object) in
//            if let info : GKNovelChapterInfo = GKNovelChapterInfo.deserialize(from:object.rawString()){
//                sucesss(info);
//            }else{
//                failure("error");
//            }
//        }, failure: failure);
        BaseNetSystem.baseUrlString(url: BaseNetManager.hostUrl(txcode:url), method: .get, parameters: ["view":"chapters"], headers: [:], sucesss: { (object) in
            print(object)
            if let info : GKNovelChapterInfo = GKNovelChapterInfo.deserialize(from:object.rawString()){
                    sucesss(info);
                }else{
                failure("error");
            }
        }, failure: failure);
    };
    class func bookContent(link:String,sucesss:@escaping ((_ object : GKNovelContent) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let string:String = GKTool.stringURLEncode(link);
        //let string:String = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let url :String = "https://chapter2.zhuishushenqi.com/chapter/" + String(string);
        BaseNetManager.iGetUrlString(urlString:url, parameters: [:], sucesss: { (object) in
            if let model : GKNovelContent = GKNovelContent.deserialize(from: object["chapter"].rawString()){
                sucesss(model);
            }else{
                failure("error");
            }
        }, failure: failure)
        
    };
    class func bookContentModel(bookId:String, model:GKNovelChapter,sucesss:@escaping ((_ object : GKNovelContent) ->Void),failure:@escaping ((_ error : String) ->Void)){
        GKBookCacheDataQueue.getContentFromDataBase(bookId:bookId, chapterId: model.chapterId) { (content) in
            if content.content.count > 0 {
                sucesss(content);
            }else{
                GKNovelNet.bookContent(link: model.link, sucesss: { (content) in
                    content.bookId = model.bookId;
                    sucesss(content);
                    if content.content.count > 0 && content.bookId.count > 0{
                        GKBookCacheDataQueue.insertContentToDataBase(bookId:bookId, content: content, completion: { (success) in
                            
                        })
                    }
                }, failure:failure);
            }
        };
    }
}
