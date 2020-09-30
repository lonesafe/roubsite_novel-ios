//
//  GKClassifyNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKClassifyNet: NSObject {
    class func getBigSort(sucesss:@escaping ((_ object : JSON) -> Void),failure:@escaping ((_ error : String) ->Void)){
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"sort/getBigSort"), parameters:[:], sucesss:sucesss, failure: failure);
    };
    class func getSmallSort(pId:String,sucesss:@escaping ((_ object : JSON) -> Void),failure:@escaping ((_ error : String) ->Void)){
        let params:Dictionary = ["parentId":pId];
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"sort/getSmallSort"), parameters:params, sucesss:sucesss, failure: failure);
    };
    class func classifyTail(group:String,name:String,page:NSInteger,sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->())){
        let params:Dictionary = ["gender":group,"type":"hot","major":name,"start":String(page),"limit":String(RefreshPageSize),"minor":""];
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"book/by-categories"), parameters: params, sucesss: sucesss, failure: failure);
    }
    class func bookDetail(bookId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "book/"+(bookId)
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:url), parameters:[:], sucesss: sucesss, failure: failure);
    }
    class func bookUpdate(bookId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "book/"+(bookId)
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:url), parameters:["id":bookId,"view":"updated"], sucesss: sucesss, failure: failure);
    }
    class func bookCommend(bookId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "book/"+(bookId)+"/recommend";
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:url), parameters:[:], sucesss: sucesss, failure: failure);
    }
    class func bookSearch(hotWord:String,page:NSInteger,size:NSInteger,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "book/fuzzy-search"
        BaseNetManager.iGetUrlString(urlString: BaseNetManager.hostUrl(txcode: url), parameters: ["query":hotWord,"start":String(page - 1),"limit":String(size)], sucesss: sucesss, failure: failure)
    }
}
