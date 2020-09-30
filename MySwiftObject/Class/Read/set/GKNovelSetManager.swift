//
//  GKNovelSetManager.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

private let set = GKNovelSetManager();

class GKNovelSetManager: NSObject {
    static var manager : GKNovelSetManager{//2
        return set
    }
    var config : GKNovelSet?{
        get{
            let defaults :UserDefaults = UserDefaults.standard;
            let data = defaults.object(forKey:GKSetInfo)
            let json = JSON(data as Any)
            if let model : GKNovelSet = GKNovelSet.deserialize(from: json.rawString()){
                return model
            }
            return GKNovelSet()
        }
    }
    class func setNight(night:Bool){
        let config : GKNovelSet = GKNovelSetManager.manager.config!
        if config.night != night {
            config.night = night
            GKNovelSetManager.saveModel(model: config)
        }
    }
    class func setLandscape(landscape:Bool){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.landscape != landscape {
            model.landscape = landscape
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setTraditiona(traditiona:Bool){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.traditiona != traditiona {
            model.traditiona = traditiona
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setBrightness(brightness:Float){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.brightness != brightness {
            model.brightness = brightness
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setFontName(fontName:String){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.fontName != fontName {
            model.fontName = fontName
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setFont(font:Float){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.font != font {
            model.font = font
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setSkin(skin:GKNovelTheme){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.skin != skin {
            model.skin = skin
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func setBrowse(browse:GKNovelBrowse){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.browse != browse {
            model.browse = browse
            GKNovelSetManager.saveModel(model: model)
        }
    }
    class func saveModel(model:GKNovelSet){
        let defaults :UserDefaults = UserDefaults.standard
        if let data = model.toJSON(){
            defaults.set(data, forKey:GKSetInfo)
            defaults.synchronize();
        }
    }
    class func defaultFont()-> [NSAttributedString.Key: Any]{
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(model.lineSpacing )//段落 行间距
        paragraphStyle.firstLineHeadIndent  = CGFloat(model.firstLineHeadIndent )//首行缩进
        paragraphStyle.paragraphSpacingBefore = CGFloat(model.paragraphSpacingBefore ) //段间距，当前段落和上个段落之间的距离。
        paragraphStyle.paragraphSpacing = CGFloat(model.paragraphSpacing ) //段间距，当前段落和下个段落之间的距离。
        paragraphStyle.alignment = .justified//两边对齐
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        var att :[NSAttributedString.Key : Any] = [:]
        let font : UIFont = UIFont.init(name: model.fontName, size:CGFloat(model.font))!
        let color : UIColor = (model.skin == .caffee) ? UIColor.init(hex: "dddddd") : UIColor.init(hex:model.color )
        att.updateValue(font, forKey: NSAttributedString.Key.font)
        att.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
        att.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        return att
    }
    class func defaultSkin() ->UIImage{
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if model.night {
            return UIImage.init(named: "icon_read_black")!
        }
        return UIImage.init(named: model.skin.rawValue)!
    }
    class func themes() -> [String]{
        return [GKNovelTheme.defaults.rawValue,GKNovelTheme.green.rawValue,GKNovelTheme.caffee.rawValue,GKNovelTheme.pink.rawValue,GKNovelTheme.fen.rawValue,GKNovelTheme.zi.rawValue,GKNovelTheme.yellow.rawValue,GKNovelTheme.phone.rawValue,GKNovelTheme.hite.rawValue];
    }
}

