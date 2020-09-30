//
//  GKBookCacheDataQueue.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON
private let primaryId = "bookId";
class GKBookCacheDataQueue: NSObject {
    
    class func insertContentToDataBase(bookId:String, content:GKNovelContent,completion:@escaping ((_ success : Bool) -> Void)){
        BaseDataQueue.insertData(toDataBase:bookId, primaryId: primaryId, userInfo: content.toJSON()!, completion: completion);
    }
    class func getContentFromDataBase(bookId:String, chapterId:String,completion:@escaping ((_ content : GKNovelContent) -> Void)){
        BaseDataQueue.getDataFromDataBase(bookId, primaryId: primaryId, primaryValue: chapterId) { (object) in
            let json = JSON(object)
            if let model = GKNovelContent.deserialize(from: json.rawString()){
                completion(model);
            }else{
                completion(GKNovelContent.init());
            }
        }
    }
    class func dropTableFromDataBase(bookId:String,completion:@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.dropTableDataBase(bookId, completion: completion);
    }
}
