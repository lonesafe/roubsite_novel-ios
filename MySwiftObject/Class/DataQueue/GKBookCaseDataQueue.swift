//
//  GKBookCaseDataQueue.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

private let tableName = "bookCase";
private let primaryId = "bookId";

class GKBookCaseDataQueue: NSObject {
    class func insertBookModel(bookDetail:GKBookModel,sucesss:@escaping ((_ success : Bool) ->Void)){
        bookDetail.updateTime = GKNumber.timeStamp();
        BaseDataQueue.insertData(toDataBase: tableName, primaryId: primaryId, userInfo: bookDetail.toJSON()!) { (res) in
            if res{
                RoubSiteBlockNet.reloadHomeData(options: RoubSiteNovelLoadOptions.Database)
            }
            sucesss(res)
        }
    }
    class func deleteBookModel(bookId:String,sucesss:@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.deleteData(toDataBase: tableName, primaryId: primaryId, primaryValue: bookId) { (res) in
            if res{
                RoubSiteBlockNet.reloadHomeData(options: RoubSiteNovelLoadOptions.Database)
            }
            sucesss(res)
        }
    }
    class func getBookModel(bookId:String,sucesss:@escaping ((_ bookModel : GKBookModel) ->Void)){
        BaseDataQueue.getDataFromDataBase(tableName, primaryId: primaryId, primaryValue: bookId) { (object) in
            let json = JSON(object)
            if let model : GKBookModel = GKBookModel.deserialize(from: json.rawString()){
                sucesss(model)
            }else{
                sucesss(GKBookModel())
            }
        }
    }
    class func getBookModels(page :Int,size: Int,sucesss:@escaping ((_ listData : [GKBookModel]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(tableName, primaryId: primaryId, page: page, pageSize: size) { (object) in
            let json = JSON(object);
            var arrayDatas :[GKBookModel] = [];
            if let data = [GKBookModel].deserialize(from: json.rawString()){
               arrayDatas = data as! [GKBookModel];
            }
            sucesss(GKBookCaseDataQueue.sortDatas(listDatas: arrayDatas, aspeing: false))
        }
    }
    class func getBookModels(sucesss:@escaping ((_ listData :[GKBookModel]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(tableName, primaryId: primaryId) { (object) in
            let json = JSON(object);
            var arrayDatas :[GKBookModel] = [];
            if let data = [GKBookModel].deserialize(from: json.rawString()){
                arrayDatas = data as! [GKBookModel]
            }
            sucesss(GKBookCaseDataQueue.sortDatas(listDatas: arrayDatas, aspeing: false))
            
        };
    }
    ////yes 升序
    class func sortDatas(listDatas:[GKBookModel],aspeing : Bool) ->[GKBookModel]{
        var datas  = listDatas;
        datas.sort { (model1, model2) -> Bool in
            return (Double(model1.updateTime) < Double(model2.updateTime))  ? aspeing : !aspeing;
        }
        return datas;
    }
}
