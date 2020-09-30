//
//  GKNovelContent.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON
class GKNovelContent: HandyJSON {

    var bookId   :String = ""
    var chapterId:String = ""
    var title    :String = ""
    var content  :String = ""
    var traditional:String = ""
    var created  :String = ""
    var updated  :String = ""
    
    var isVip    :Bool = false
    
    var position :Float = 0.0
    var pageIndex:Int = 0
    var pageCount:Int = 0
    
    private lazy var pageArray: [Int] = {
        return []
    }()
    private lazy var attributedString: NSAttributedString = {
        return NSAttributedString.init();
    }()

    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.chapterId <-- ["bookId","id",]
        mapper <<<
            self.content   <-- ["cpContent","body","content"]
    }
    func pageContent(){
        self.pageBound(bound:AppFrame)
    }
    private func pageBound(bound:CGRect){
        self.pageArray.removeAll();
        let content : String = self.lineContent ?? ""

        let attr :NSMutableAttributedString = NSMutableAttributedString.init(string: content, attributes: (GKNovelSetManager.defaultFont() ))
        let frameSetter :CTFramesetter = CTFramesetterCreateWithAttributedString(attr);
        let path :CGPath = CGPath(rect: bound,transform: nil);
        var range :CFRange = CFRangeMake(0, 0);
        var rangeOffset:Int = 0;
        while range.location + range.length < attr.length {
            let frame :CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil);
            range = CTFrameGetVisibleStringRange(frame);
            rangeOffset += range.length;
            self.pageArray.append(range.location)
        }
        self.pageCount = self.pageArray.count;
        self.attributedString = attr;
    }
    func attContent(page:NSInteger) ->NSAttributedString{
        if self.pageArray.count == 0{
            return NSAttributedString.init(string: "数据控控如也...")
        }
        let index = (page >= self.pageArray.count) ?self.pageArray.count - 1:page
        let loc :Int = self.pageArray[index];
        var len :Int = 0;
        if index == (self.pageArray.count - 1) {
            len = self.attributedString.length - loc;
        }else{
            len = self.pageArray[index+1]-loc;
        }
        let att :NSAttributedString = self.attributedString.attributedSubstring(from: NSRange.init(location: loc, length: len));
        return att;
    }
    private var lineContent :String?{
        get{
            var content :String = self.content
            content = content.replacingOccurrences(of: "\n\r", with: "\n")
            content = content.replacingOccurrences(of: "\r\n", with: "\n")
            content = content.replacingOccurrences(of: "\n\n", with: "\n")
            content = content.replacingOccurrences(of: "\t\n", with: "\n")
            content = content.replacingOccurrences(of: "\t\t", with: "\n")
            content = content.replacingOccurrences(of: "\n\n", with: "\n")
            content = content.replacingOccurrences(of: "\r\r", with: "\n")
            content = content.trimmingCharacters(in: .whitespacesAndNewlines);
            content = self.removeLine(content: content);
            return content;
        }
    }
    private func removeLine(content:String) ->String{
        var datas : NSArray = content.components(separatedBy: CharacterSet.newlines) as NSArray;
        let pre = NSPredicate.init(format:"self <> ''");
        datas = datas.filtered(using: pre) as NSArray
        var list : [String] = [];
        datas.forEach { (object) in
            var str = object as! String;
            str = str.trimmingCharacters(in: .whitespacesAndNewlines)
            list.append(str);
        }
        return list.joined(separator: "\n");
    }
}
