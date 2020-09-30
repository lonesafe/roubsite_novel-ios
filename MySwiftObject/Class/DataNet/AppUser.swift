//
//  AppUser.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2020/4/1.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AppLocation : Codable {
    var latitude : CGFloat? = 0;
    var longitude : CGFloat? = 0;
}

class AppUser: Codable {
    var userId : String? = "";
    var name : String? = "";
    var body : String? = "";
    var height : CGFloat? = 0;
    var weight : CGFloat? = 0;
    
    enum CodingKeys: String, CodingKey {
        case userId = "_id"
        case name
        case height
        case weight
        case body
    }
}
class AppUserExtern : AppUser{
    var age : Int? =  0;
    var location : AppLocation? = nil
    enum CodingKeys: String, CodingKey {
        case age
        case location
    }
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//    }
}


class AppTool : NSObject{
    class func appTool(){
        let jsonData = """
        {
        "_id": "100001",
        "name": "swift",
        "age": 24,
        "level": "large",
        "location": {
          "latitude": 30.40,
          "longitude": 120.51
        }
        }
        """.data(using: .utf8)!
        do {
            let user : AppUser = try JSONDecoder().decode(AppUser.self, from:jsonData)
            print(user.name ?? "");
            print(user.weight ?? 0);
            print(user.userId ?? "");
        } catch {
            print("error: \(error)")
        }
        
        do {
            let extern : AppUserExtern = try JSONDecoder().decode(AppUserExtern.self, from:jsonData)
            print(extern.name ?? "");
            print(extern.weight ?? 0);
            print(extern.userId ?? "");
            print(extern.age ?? 0);
            print(extern.location as Any);
        } catch {
            print("error: \(error)")
        }
        
    }
}
