//
//  BaseRefreshController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import ATRefresh_Swift
import Alamofire
public let RefreshPageStart : Int = (1)
public let RefreshPageSize  : Int = (20)

class BaseRefreshController: ATRefreshController {
    open var reachable: Bool {
        return NetworkReachabilityManager.init()!.isReachable;
    }
    private lazy var images: [UIImage] = {
        var images :[UIImage] = [];
        for i in 0...4{
            let image = UIImage.init(named:String("loading")+String(i));

            if image != nil {
                images.append(image!);
            }
        }
        for i in 0...4{
            let image = UIImage.init(named:String("loading")+String(4 - i));

            if image != nil {
                images.append(image!);
            }
        }
        return images;
    }()
    deinit {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
    }
    
}
extension BaseRefreshController : ATRefreshDataSource{
    var refreshFooterData: [UIImage] {
        return self.images
    }
    
    var refreshHeaderData: [UIImage] {
        return self.images
    }
    
    var refreshLoaderData: [UIImage] {
        return self.images
    }
    
    var refreshEmptyData: UIImage {
        return UIImage.init(named: "icon_data_empty") ?? UIImage.init()
    }
    
    var refreshErrorData: UIImage {
        return UIImage.init(named: "icon_net_error") ?? UIImage.init()
    }
    
    var refreshEmptyToast: String{
        return "这里啥都没有😄"
    }
    var refreshLoaderToast: String{
        return "我正在找⛽️"
    }
    var refreshErrorToast: String{
        return "网络错误😭"
    }
}
