//
//  GKNovelSource.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class GKNovelSource: HandyJSON {
    
    var sourceId :String? = "";
    var chaptersCount:Int? = 0;
    var host:String? = "";
    var isCharge:Bool? = false;
    var lastChapter:String? = "";
    var link:String? = "";
    var name:String? = "";
    var source:String? = "";
    var starting:String? = "";
    var updated:String? = "";
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.sourceId <-- ["sourceId","_id"]
    }
    required init() {}
}
