//
//  GKNumber.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKNumber: NSObject {
    class func getCount(count:Int) ->String{
        if count > 10000 {
            let value :Float = Float(count/10000);
            return String(value)+"万"
        }
        return String(count);
    }
    class func getTime(timeStamp:TimeInterval) -> String{
        let date:NSDate = NSDate.init(timeIntervalSince1970:timeStamp);
        let formatter:DateFormatter = DateFormatter.init();
        formatter.dateFormat = "YYYY.MM.dd HH:mm"
        return formatter.string(from: date as Date);
    }
    class func timeStamp() -> TimeInterval{
        let time : TimeInterval = Date.init().timeIntervalSince1970;
        return time;
    }
}
