//
//  GKDetailTopView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKDetailTopView: UIView {
    private lazy var mainView: UIImageView = {
        var mainView : UIImageView = UIImageView.init();
        return mainView;
    }()
    @IBOutlet weak var topImageV: NSLayoutConstraint!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var chapterLab: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var focusLab: UIButton!

    @IBOutlet weak var backAction: UIButton!
    var _model : GKBookDetailModel!
    var model : GKBookDetailModel{
        set{
            _model = newValue;
            self.imageV.setGkImageWithURL(url: _model.cover ?? "");
            self.mainView.setGkImageWithURL(url: _model.cover ?? "");
            self.titleLab.text = _model.title! + (!_model.isSerial! ?"(完结)":"(连载)");
            self.subTitleLab.text =  "最新章节:" + _model.lastChapter! ;
            self.nickNameLab.text = _model.author ?? "";
            self.countLab.text = "字数:" + GKNumber.getCount(count: _model.wordCount ?? 0);
            self.chapterLab.text = "章节数:" + String(_model.chaptersCount ?? "0");
            self.focusLab.setTitle("关注度" + String(_model.retentionRatio) + "%", for: .normal)
            
        }get{
            return _model;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = AppRadius
        self.addSubview(self.mainView);
        self.sendSubviewToBack(self.mainView);
        self.mainView.layer.masksToBounds = true;
        self.focusLab.layer.masksToBounds = true;
        self.focusLab.layer.cornerRadius = 5;
        self.topImageV.constant = CGFloat(NAVI_BAR_HIGHT);
        let effect: UIBlurEffect = UIBlurEffect.init(style: .dark);
        let effectView :UIVisualEffectView = UIVisualEffectView.init(effect: effect);
        self.mainView.addSubview(effectView);
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    class func getHeight(model:GKBookDetailModel)->CGFloat{
        let cell :GKDetailTopView = GKDetailTopView.instanceView()
        cell.model = model;
        let cont:NSLayoutConstraint = NSLayoutConstraint.init(item: cell, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: SCREEN_WIDTH);
        cell.addConstraint(cont);
        let height =   cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        cell.removeConstraint(cont);
        return height;
        
    }
    override func layoutSubviews() {
        self.mainView.frame = self.frame;
    }
}
