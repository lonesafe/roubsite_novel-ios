//
//  GKMineModel.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKMineModel: BaseModel {
    var title:String    = "";
    var icon:String     = "";
    var subTitle:String = "";
    class func vcWithModel(title:String,icon:String,subTitle:String) -> Self{
        let vc:GKMineModel = GKMineModel.init();
        vc.title = title;
        vc.subTitle = subTitle;
        vc.icon = icon;
        
        return vc as! Self;
    }

}
