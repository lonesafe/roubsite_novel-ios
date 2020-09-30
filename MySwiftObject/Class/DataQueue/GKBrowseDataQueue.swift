//
//  GKBrowseDataQueue.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

private let tableName = "bookBrowse";
private let primaryId = "bookId";

class GKBrowseDataQueue: NSObject {
    class func insertBookModel(browse:GKBrowseModel,completion: @escaping ((_ success : Bool) ->Void)){
        browse.updateTime = GKNumber.timeStamp();
        BaseDataQueue.insertData(toDataBase:tableName, primaryId: primaryId, userInfo:browse.toJSON()!, completion: completion)
    }
    class func deleteBookModel(bookId:String,completion:@escaping ((_ success : Bool) ->())){
        BaseDataQueue.deleteData(toDataBase: tableName, primaryId: primaryId, primaryValue: bookId, completion: completion);
    }
    class func getBookModel(bookId:String,completion:@escaping ((_ bookModel : GKBrowseModel) ->Void)){
        BaseDataQueue.getDataFromDataBase(tableName, primaryId: primaryId, primaryValue: bookId) { (object) in
            let json = JSON(object);
            if let model : GKBrowseModel = GKBrowseModel.deserialize(from: json.rawString()){
                completion(model);
            }else{
                completion(GKBrowseModel.init());
            }
        }
    }

    class func getBookModel(page:NSInteger,size:NSInteger,completion:@escaping ((_ listData : [GKBrowseModel]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(tableName, primaryId:primaryId, page:page, pageSize: size) { (respond) in
            var dats:[GKBrowseModel] = [];
            let json = JSON(respond);
            if let list : [JSON] = json.array{
                for obj in list{
                    var newData = obj;
                    newData["chapterInfo"] = [];
                    if let model : GKBrowseModel = GKBrowseModel.deserialize(from: newData.rawString()){
                        dats.append(model)
                    }
                }
            }
            completion(GKBrowseDataQueue.sortDatas(listDatas: dats, ascending:false));
        };
    }
    //yes 升序
    class func sortDatas(listDatas:[GKBrowseModel],ascending : Bool) ->[GKBrowseModel]{
        var datas  = listDatas;
        datas.sort { (model1, model2) -> Bool in
            return Double(model1.updateTime) < Double(model2.updateTime)  ? ascending : !ascending;
        }
        return datas;
    }
}
