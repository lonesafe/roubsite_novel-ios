//
//  ATMacro.swift
//  ATKit_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import Foundation
import UIKit

public class ATMacro : NSObject {
    public class func iPhone() -> Bool{
        return UIDevice.current.userInterfaceIdiom == .phone ? true : false
    }
    public class func Status_Bar() ->CGFloat{
        return (ATMacro.iPhoneX() ? 44: 20)
    }
    public class func Navi_Bar() ->CGFloat{
        return (ATMacro.iPhoneX() ? 88: 64)
    }
    public class func Tab_Bar() ->CGFloat{
        return (ATMacro.iPhoneX() ? 34: 0)
    }
    public class func iPhoneX() -> Bool{
        let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!
           if #available(iOS 11.0, *) {
               let inset : UIEdgeInsets = window.safeAreaInsets
            if (inset.bottom == 34 || inset.bottom == 21) && ATMacro.iPhone() {
                   return true;
               }else{
                   return false
               }
           } else {
              return false;
           };
    }
    public class func imageWithColor(color:UIColor) -> UIImage{
          let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
          UIGraphicsBeginImageContext(rect.size)
          let context = UIGraphicsGetCurrentContext()
          context!.setFillColor(color.cgColor)
          context!.fill(rect)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image!
      }
}
