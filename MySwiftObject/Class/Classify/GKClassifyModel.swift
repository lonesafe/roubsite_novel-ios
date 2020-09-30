//
//  GKClassifyModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKClassifyModel : Codable {
    
    var title     :String? = ""
    var cover     :String? = ""
    var monthlyCount:Int? = 0
    var icon      :String? = ""
    var bookCount :Int? = 0
    var bookCover :[String]? = []
    var id:String? = ""
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case cover
        case monthlyCount
        case icon
        case bookCount
        case bookCover
        case id
    }
}
