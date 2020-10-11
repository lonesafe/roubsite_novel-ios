//
//  GKClassifyNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoubSiteNovelClassifyNet: NSObject {
    class func getBigSort(sucesss:@escaping ((_ object : JSON) -> Void),failure:@escaping ((_ error : String) ->Void)){
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"sort/getBigSort"), parameters:[:], sucesss:sucesss, failure: failure);
    };
    class func getSmallSort(pId:String,sucesss:@escaping ((_ object : JSON) -> Void),failure:@escaping ((_ error : String) ->Void)){
        let params:Dictionary = ["parentId":pId];
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"sort/getSmallSort"), parameters:params, sucesss:sucesss, failure: failure);
    };
    class func classifyTail(sortId:String,type:String,page:NSInteger,sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->())){
        let params:Dictionary = ["sortId":sortId,"type":type,"page":String(page),"limit":String(RefreshPageSize)];
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:"sort/getNovelList"), parameters: params, sucesss: sucesss, failure: failure);
    }
    class func bookDetail(bookId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let params:Dictionary = ["novelId":bookId];
        let url = "novel/getNovelInfo";
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:url), parameters:params, sucesss: sucesss, failure: failure);
    }
    class func bookCommend(bookId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "novel/randomNovels";
        BaseNetManager.iGetUrlString(urlString:BaseNetManager.hostUrl(txcode:url), parameters:[:], sucesss: sucesss, failure: failure);
    }
    class func bookSearch(hotWord:String,page:NSInteger,size:NSInteger,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "search"
        BaseNetManager.iPostUrlString(urlString: BaseNetManager.hostUrl(txcode: url), parameters: ["keyWord":hotWord,"page":String(page),"limit":String(size)], sucesss: sucesss, failure: failure)
    }
}
