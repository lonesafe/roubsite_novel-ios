//
//  GKLoad.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView{
    public func setGkImageWithURL(url:String){
        self.setGkImageWithURL(url: url, placeholder: placeholder)
    }
    public func setGkImageWithURL(url:String,placeholder:UIImage){
        self.setGkImageWithURL(url: url, placeholder: placeholder, unencode: true);
    }
    public func setGkImageWithURL(url:String,placeholder:UIImage,unencode:Bool){
        var str : String = "";
        if url.hasPrefix("/agent/"){
            str = url.replacingOccurrences(of: "/agent/", with: "");
        }
        str = unencode ? str.removingPercentEncoding! : str;
        self.kf.setImage(with: URL.init(string: str),placeholder: placeholder)
    }
//    public func downGkImageWithURL(url:String,placeholder:UIImage,unencode:Bool,completion:@escaping((_ image:UIImage,_ success:Bool) -> Void)){
//        var str : String!;
//        if url.hasPrefix("/agent/"){
//            str = url.replacingOccurrences(of: "/agent/", with: "");
//        }
//        str = unencode ? str.removingPercentEncoding : str;
//        self.kf.setImage(with: URL.init(string: str), placeholder: placeholder, options: nil, progressBlock: nil) { (Result<RetrieveImageResult, KingfisherError>) in
//            
//        }
//        self.sd_setImage(with: URL.init(string: str), placeholderImage: placeholder, options: .cacheMemoryOnly) { (image, error, type, url) in
//            if error == nil{
//                completion(image!,true);
//            }else{
//                completion(image!,false);
//            }
//        }
//    }
    
}

