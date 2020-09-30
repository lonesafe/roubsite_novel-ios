//
//  GKNovelSet.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

enum GKNovelTheme : String,HandyJSONEnum{
    case defaults = "icon_default"
    case green    = "icon_read_green"
    case caffee   = "icon_read_coffee"
    case pink     = "icon_read_fenweak"
    case fen      = "icon_read_fen"
    case zi       = "icon_read_zi"
    case yellow   = "icon_read_yellow"
    case phone    = "icon_phone"
    case hite     = "icon_hite"
}
enum GKNovelBrowse : Int,HandyJSONEnum{
    case defaults = 0
    case pageCurl = 1
    case none     = 2
}
class GKNovelSet: HandyJSON {
    var color:String        = "333333"
    var fontName:String     = "PingFang-SC-Regular"
    var font : Float        = 18
    var lineSpacing :Float  = 5
    var firstLineHeadIndent : Float   = 20
    var paragraphSpacingBefore :Float = 5
    var paragraphSpacing : Float      = 5
    var brightness :Float             = 0
    
    var night :Bool                   = false
    var landscape :Bool               = false
    var traditiona :Bool              = false
    
    var skin   :GKNovelTheme          = .defaults
    var browse :GKNovelBrowse         = .defaults
    required init() {}
}

