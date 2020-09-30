//
//  GKHomeNet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GKLoadOptions :OptionSet {
    public var rawValue: UInt
    
    static var None     : GKLoadOptions{return GKLoadOptions(rawValue: 0)}
    static var DataNet  : GKLoadOptions{return GKLoadOptions(rawValue: 1<<1)};
    static var Database : GKLoadOptions{return GKLoadOptions(rawValue: 1<<2)};
    static var Default  : GKLoadOptions{return GKLoadOptions(rawValue: DataNet.rawValue|Database.rawValue)}
}
private let netManager = GKHomeNet();
class GKHomeNet: NSObject {
    private var completion : ((_ options :GKLoadOptions) -> Void)!;
    private lazy var listData: [GKHomeInfo] = {
        return []
    }()
    private lazy var arrayData : [GKHomeInfo] = {
        return []
    }()
    private var bookCase : GKHomeInfo!;
    static let manager = GKHomeNet();
     func homeNet(options:GKLoadOptions,sucesss:@escaping ((_ datas : [GKHomeInfo]) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let group : DispatchGroup = DispatchGroup.init();
        var value = options.rawValue & GKLoadOptions.DataNet.rawValue;
        let userData :GKUserModel = GKUserManager.getModel();
        if value == 2 {
            self.arrayData.removeAll();
            if userData.rankDatas.count > 0 {
                for obj in userData.rankDatas{
                    let model :GKRankModel = obj as GKRankModel;
                    group.enter();
                    GKHomeNet.homeHot(rankId:model.rankId, sucesss: { (object) in
                        if let info : GKHomeInfo = GKHomeInfo.deserialize(from: object["ranking"].rawString()){
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
        value = options.rawValue & GKLoadOptions.Database.rawValue;
        if value == 4 {
            group.enter();
            GKBookCaseDataQueue.getBookModels { (datas) in
                if datas.count > 0{
                    let info :GKHomeInfo = GKHomeInfo();
                    info.state = GKHomeInfoState.Database
                    info.books = datas
                    info.title = "我的书架"
                    info.shortTitle = "我的书架"
                    self.bookCase = info;
                }else{
                    self.bookCase = nil;
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.listData.removeAll();
            if self.bookCase != nil{
                self.listData.append(self.bookCase);
            }
            if self.arrayData.count > 0 {
                self.listData.append(contentsOf: self.arrayData);
            }
            if self.listData.count > 0{
                sucesss(self.listData) ;
            }else{
                failure("数据空空如也");
            }
        }
    }
    class func homeHot(rankId:String,sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let url = "ranking/"+(rankId);
        BaseNetManager.baseCodeUrl(urlString: BaseNetManager.hostUrl(txcode:url), method: .get, parameters: [:], sucesss: sucesss, failure: failure);
    }
    class func homeSex(sucesss:@escaping ((_ object : JSON) -> Void),failure:@escaping ((_ error : String) ->Void)){
        BaseNetManager.baseCodeUrl(urlString: BaseNetManager.hostUrl(txcode:"ranking/gender"), method: .get, parameters: [:], sucesss: sucesss, failure: failure);
    }
    class func reloadHomeData(options : GKLoadOptions){
        if GKHomeNet.manager.completion != nil {
            GKHomeNet.manager.completion(options);
        }
    }
    class func reloadHomeDataNeed(completion: @escaping ((_ options :GKLoadOptions) ->Void)){
        GKHomeNet.manager.completion = completion;
    }
}
