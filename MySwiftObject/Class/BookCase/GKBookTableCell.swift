//
//  GKBookTableCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBookTableCell: UICollectionViewCell {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    
    var model:GKBookModel?{
        didSet{
            guard let item = model else { return }
            self.imageV.setGkImageWithURL(url: item.cover  ?? "");
            self.titleLab.text = item.title ?? "";
            self.contentLab.text = item.shortIntro ?? "";
            self.nickNameLab.text = item.author ?? "";
            self.countLab.text = GKNumber.getCount(count: item.latelyFollower ?? 0);
            self.stateBtn.setTitle(item.majorCate ?? "", for: .normal);
            self.stateBtn.isHidden = (item.majorCate!.count > 0) ? false : true;
            self.favBtn.setTitle("关注:"+String(item.retentionRatio)+("%"), for: .normal);
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stateBtn.layer.masksToBounds = true;
        self.stateBtn.layer.cornerRadius = 7.5;
        self.favBtn.layer.masksToBounds = true;
        self.favBtn.layer.cornerRadius = 10;
        
        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = AppRadius
        // Initialization code
    }

}
