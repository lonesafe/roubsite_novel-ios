//
//  GKCache.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2020/6/23.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

import SwiftyJSON

private let cache = YYMemoryCache.init()
class GKCache: NSObject {
    public class func removeAll(){
        cache.removeAllObjects()
    }
    public class func clear(key :String){
        cache.removeObject(forKey: key)
    }
    public class func set(object : [String:Any],key :String){
        cache.setObject(object, forKey: key)
    }
    public class func values(key: String) -> JSON {
        let object = cache.object(forKey: key)
        return JSON(object as Any)
    }
}
