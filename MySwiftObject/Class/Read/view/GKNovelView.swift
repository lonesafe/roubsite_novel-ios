//
//  GKNovelView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKNovelView: UIView {

    var contentFrame :CTFrame!
    var content :NSAttributedString = NSAttributedString.init(string: ""){
        didSet{
            self.setNeedsDisplay()
        }
    }
    override func layoutSubviews() {
        super .layoutSubviews();
        let setterRef:CTFramesetter = CTFramesetterCreateWithAttributedString(self.content);
        let pathRef :CGPath = CGPath(rect: self.bounds,transform: nil)
        let frameRef :CTFrame = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil);
        self.contentFrame = frameRef;
    }
    override func draw(_ rect: CGRect) {
        if self.contentFrame == nil {
            return;
        }
        let ctx : CGContext = UIGraphicsGetCurrentContext()!;
        ctx.textMatrix = .identity;
        ctx.translateBy(x: 0, y: self.bounds.height)
        ctx.scaleBy(x: 1, y: -1)
        CTFrameDraw(self.contentFrame, ctx);
    }

}
