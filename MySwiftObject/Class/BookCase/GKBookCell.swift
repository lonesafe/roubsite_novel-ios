//
//  GKBookCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBookCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var statebtn: UIButton!
    var model : GKBookModel?{
        didSet{
            guard let item = model else { return }
            self.imageV.setGkImageWithURL(url: item.cover ?? "");

            self.titleLab.text = item.title;
            self.subTitleLab.text = item.author ?? "";
            self.statebtn .setTitle(item.minorCate ?? "", for: .normal);
            self.statebtn.isHidden = item.minorCate!.count == 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.statebtn.layer.masksToBounds = true;
        self.statebtn.layer.cornerRadius = 7.5;
        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = AppRadius
        // Initialization code
    }

}
