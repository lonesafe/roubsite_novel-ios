//
//  GKRankInfo.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class RoubSiteNovelBlockInfo: HandyJSON {
    var blockId:String   = "";
    var collapse:String? = "";
    var cover:String? = "";
    var monthRank:String? = "";
    var shortTitle:String? = "";
    var title:String? = "";
    var totalRank:String? = "";
    var select:Bool? = false;
    required init() {}
    
}
class GKRankInfo: BaseModel {
    var male:[RoubSiteNovelBlockInfo]? = [];
    var female:[RoubSiteNovelBlockInfo]? = [];
    var state:Int? = 0;
}
