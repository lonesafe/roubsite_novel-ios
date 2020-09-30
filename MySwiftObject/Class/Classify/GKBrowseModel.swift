//
//  GKBrowseModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class GKBrowseModel: HandyJSON {
    
    var bookId     :String?       = "";
    var updateTime :TimeInterval  = 0;
    var chapter    :NSInteger?    = 0;
    var pageIndex  :NSInteger?    = 0;
    
    var bookModel  :GKBookModel!;
    var source     :GKNovelSource!;
    var chapterInfo:GKNovelChapterInfo!;
    
    required init() {}
}
