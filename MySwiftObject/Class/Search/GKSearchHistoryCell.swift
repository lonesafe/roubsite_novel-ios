//
//  GKSearchHistoryCell.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKSearchHistoryCell: UITableViewCell {
    lazy var imageV : UIImageView = {
        let imageV : UIImageView = UIImageView.init();
        imageV.image = UIImage.init(named: "icon_history");
        return imageV;
    }()
    lazy var titleLab : UILabel = {
        let titleLab : UILabel = UILabel.init();
        titleLab.font = UIFont.systemFont(ofSize: 14);
        titleLab.textColor = UIColor.init(hex: "666666");
        titleLab.textAlignment = .left;
        return titleLab
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.addSubview(self.imageV);
        self.contentView.addSubview(self.titleLab);
        self.imageV.snp_makeConstraints { (make) in
            make.width.height.equalTo(30);
            make.left.equalToSuperview().offset(15);
            make.centerY.equalToSuperview();
        }
        self.titleLab.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.left.equalTo(self.imageV.snp_right).offset(10);
            make.right.equalToSuperview().offset(-15);
        }
//        let lineView : UIView = UIView.init();
//        lineView.backgroundColor = Appxdddddd;
//        self.contentView.addSubview(lineView);
//        lineView.snp_makeConstraints { (make) in
//            make.left.equalTo(self.imageV);
//            make.right.bottom.equalToSuperview();
//            make.height.equalTo(0.6);
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
