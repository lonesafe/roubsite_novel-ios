import UIKit
import ATKit_Swift
import Hue
import SnapKit
import SwiftyJSON

let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

let AppColor: UIColor = UIColor.init(hex: "007EFE")
let Appxdddddd: UIColor = UIColor.init(hex: "dddddd")
let Appx000000: UIColor = UIColor.init(hex: "000000")
let Appx333333: UIColor = UIColor.init(hex: "333333")
let Appx666666: UIColor = UIColor.init(hex: "666666")
let Appx999999: UIColor = UIColor.init(hex: "999999")
let Appxf8f8f8: UIColor = UIColor.init(hex: "f8f8f8")
let Appxffffff: UIColor = UIColor.init(hex: "ffffff")
let AppRadius: CGFloat = 3
let placeholder: UIImage = UIImage.imageWithColor(color: UIColor.init(hex: "f8f8f8"))

let appDatas: [String] = ["七届传说", "极品家丁", "择天记", "神墓", "遮天"]


let GKSetInfo: String = "GKSetTheme";

class BaseMacro: NSObject {
    let iPhone_X: Bool = {
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        if #available(iOS 11.0, *) {
            let inset: UIEdgeInsets = window.safeAreaInsets
            if (inset.bottom == 34 || inset.bottom == 21) {
                return true;
            } else {
                return false
            }
        } else {
            return false;
        };
    }();
    let STATUS_BAR_HIGHT: CGFloat = ATMacro.Status_Bar()//状态栏
    let NAVI_BAR_HIGHT: CGFloat = ATMacro.Navi_Bar()  //导航栏
    lazy var TAB_BAR_ADDING: CGFloat = (iPhone_X ? 34 : 0)  //iphoneX斜刘海
    lazy var AppFrame: CGRect = CGRect.init(x: 20, y: STATUS_BAR_HIGHT + 20, width: SCREEN_WIDTH - 40, height: CGFloat(SCREEN_HEIGHT - STATUS_BAR_HIGHT - 20 - 20 - TAB_BAR_ADDING));
}
