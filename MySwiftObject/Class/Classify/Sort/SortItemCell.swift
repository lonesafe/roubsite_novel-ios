//
//  SortItemCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class SortItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var model : SortBean?{
        didSet{
            guard let item = model else { return }
            self.titleLab.text = item.title ?? "";
            self.imageV.setGkImageWithURL(imageId: item.cover!);
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = AppRadius
        // Initialization code
    }

}
