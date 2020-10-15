//
//  SortBean.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class SortBean: Codable {
    
    var title     :String? = ""
    var cover     :String? = ""
    var bookCount :Int? = 0
    var id:String? = ""
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case cover
        case bookCount
        case id
    }
}
