//
//  GKUserModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
private let GKUserInfo = "GKUserInfo"
enum GKUserState : Int,HandyJSONEnum {
    case GKUserBoy  = 0
    case GKUserGirl = 1
}
class GKUserModel: HandyJSON {
    required init() {

    }
    var state : GKUserState = .GKUserBoy;
    var rankDatas : [GKRankModel] = [];
}
class GKUserManager : NSObject{
    class func saveModel(model:GKUserModel) {
        let defaults = UserDefaults.standard;
        if let dic = model.toJSON(){
            defaults.set(dic, forKey: GKUserInfo);
            defaults.synchronize();
        }
    }
    class func getModel() ->GKUserModel{
        let data = UserDefaults.standard.object(forKey:GKUserInfo);
        let json = JSON(data as Any)
        if let model : GKUserModel = GKUserModel.deserialize(from: json.rawString()){
            return model;
        }
        return GKUserModel.init()
    }
}
