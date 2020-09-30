//
//  GKNovelSetCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKNovelSetCell: UICollectionViewCell {



    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = 25;
    }
}
