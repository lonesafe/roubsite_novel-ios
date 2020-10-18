//
//  GKBookModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON
class GKBookModel:HandyJSON {
    
    var bookId    :String?       = "";
    var updateTime:TimeInterval  = 0;
    var author    :String? = "";
    var cover     :String? = "";
    var shortIntro:String? = ""
    var title     :String? = "";
    var majorCate :String? = "";
    var minorCate :String? = "";
    var lastChapter:String? = "";
    var vip:Bool? = false;
    
    var retentionRatio :Float! = 0.0;
    var size:Int? = 0;
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.bookId     <-- ["bookId","_id"]
        mapper <<<
            self.shortIntro <-- ["shortIntro","longIntro"]
    }
  
}
