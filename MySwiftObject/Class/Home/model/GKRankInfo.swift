//
//  GKRankInfo.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class GKRankModel: HandyJSON {
    var rankId :String   = "";
    var collapse:String? = "";
    var cover:String? = "";
    var monthRank:String? = "";
    var shortTitle:String? = "";
    var title:String? = "";
    var totalRank:String? = "";
    var select:Bool? = false;

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.rankId <-- ["rankId","_id"]
    }
    required init() {}
    
}
class GKRankInfo: BaseModel {
    var male:[GKRankModel]? = [];
    var female:[GKRankModel]? = [];
    var state:Int? = 0;
}
