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
        var mainView: UIImageView = UIImageView.init();
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
    var _model: GKBookDetailModel!
    var model: GKBookDetailModel {
        set {
            _model = newValue;
            self.imageV.setGkImageWithURL(imageId: _model.cover ?? "");
            self.mainView.setGkImageWithURL(imageId: _model.cover ?? "");
            self.titleLab.text = _model.title! + (!_model.isNotEnd! ? "(完结)" : "(连载)");
            self.subTitleLab.text = "最新章节:" + _model.lastChapter!;
            self.nickNameLab.text = _model.author ?? "";
            self.countLab.text = "字数:" + GKNumber.getCount(count: _model.wordCount ?? 0);
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd";
            let date: Date = Date.init(timeIntervalSince1970: _model.updateTime);
            let date1: String = formatter.string(from: date);
            self.chapterLab.text = "更新时间:" + date1;
            if (_model.vip == true) {
                self.focusLab.setTitle("付费", for: .normal)
            } else {
                self.focusLab.setTitle("免费", for: .normal)
            }


        }
        get {
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
        self.topImageV.constant = CGFloat(BaseMacro.init().NAVI_BAR_HIGHT);
        let effect: UIBlurEffect = UIBlurEffect.init(style: .dark);
        let effectView: UIVisualEffectView = UIVisualEffectView.init(effect: effect);
        self.mainView.addSubview(effectView);
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }

    class func getHeight(model: GKBookDetailModel) -> CGFloat {
        let cell: GKDetailTopView = GKDetailTopView.instanceView()
        cell.model = model;
        let cont: NSLayoutConstraint = NSLayoutConstraint.init(item: cell, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: SCREEN_WIDTH);
        cell.addConstraint(cont);
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        cell.removeConstraint(cont);
        return height;

    }

    override func layoutSubviews() {
        self.mainView.frame = self.frame;
    }
}
