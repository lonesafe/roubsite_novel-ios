//
//  GKClassifyTailCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKClassifyTailCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var focusBtn: UIButton!
    
    var model : GKBookModel?{
        didSet{
            guard let item = model else { return }
            self.imageV.setGkImageWithURL(imageId: item.cover  ?? "");
            self.titleLab.text = item.title ?? "";
            self.subTitleLab.text = item.shortIntro ?? "";
            self.nickNameLab.text = item.author ?? "";
            self.countLab.text = GKNumber.getCount(count: item.size ?? 0)+"字";
            self.stateBtn.setTitle(item.majorCate ?? "", for: .normal);
            self.stateBtn.isHidden = item.majorCate?.count == 0 ? true : false;
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd";
            let date:Date = Date.init(timeIntervalSince1970: item.updateTime);
            let date1 = formatter.string(from: date);
            self.focusBtn.setTitle(date1, for: .normal);
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stateBtn.layer.masksToBounds = true;
        self.stateBtn.layer.cornerRadius = 7.5;
        self.focusBtn.layer.masksToBounds = true;
        self.focusBtn.layer.cornerRadius = 10;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.imageV.layer.masksToBounds = true;
        self.imageV.layer.cornerRadius = AppRadius
        // Configure the view for the selected state
    }
    
    
}
