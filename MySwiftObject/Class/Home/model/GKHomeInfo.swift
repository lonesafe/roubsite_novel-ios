//
//  GKHomeInfo.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

enum GKHomeInfoState : Int {
    case DataNet
    case Database
}
class GKHomeInfo: HandyJSON {
    
    var books :[GKBookModel] = [];
    var total :Int?         = 0;
    var title :String?      = "";
    var shortTitle :String? = "";
    var homeId :String      = "";
    
    var state :GKHomeInfoState? = .DataNet
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.homeId <-- ["homeId","_id"]
    }
    var listData : [GKBookModel]{
        get{
            if self.books.count > 0 {
                let count : Int = self.books.count > 3 ? 3 : self.books.count;
                return []+self.books.prefix(count)
            }
            return [];
        }
    }
    var moreData:Bool{
        get{
            let more : Bool = self.books.count > 3 ? true : false;
            return more;
        }
    }
    required init() {
        
    }
}
