//
//  GKSexCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKSexCell: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    var model :RoubSiteNovelBlockInfo?{
        didSet{
            guard let item = model else { return }
            self.titleLab.text = item.shortTitle ?? "";
            if item.select! {
                self.titleLab.textColor = UIColor.white;
                self.titleLab.backgroundColor = AppColor;
            }else{
                self.titleLab.textColor = AppColor;
                self.titleLab.backgroundColor = UIColor.white;
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLab.layer.masksToBounds = true;
        self.titleLab.layer.cornerRadius = 5;
        self.titleLab.layer.borderWidth = 1;
        self.titleLab.layer.borderColor = AppColor.cgColor;
        self.titleLab.textColor = AppColor;
        // Initialization code
    }

}
