//
//  GKBookDetailModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBookDetailModel: GKBookModel {
    var cat          :String? = ""
    var chaptersCount:String? = ""
    var creater      :String? = ""
    
    var postCount    :Int? = 0
    var wordCount    :Int? = 0
    
    var hasSticky    :Bool? = false
    var hasUpdated   :Bool? = false
    var hasCp        :Bool? = false
    var isSerial     :Bool? = false
    var donate       :Bool? = false
    var le           :Bool? = false
    var allowVoucher :Bool? = false
}


class GKBookUpdateInfo : GKBookDetailModel{
    var tags      : [String] = []
    var copyrightInfo:String = ""
    var updated      :String = ""
}
