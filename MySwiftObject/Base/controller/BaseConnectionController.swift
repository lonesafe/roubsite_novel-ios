//
//  BaseCollectionViewController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
class BaseConnectionController: BaseRefreshController {
    lazy var collectionView : UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .vertical;
        let collectionView : UICollectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: layout);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.isScrollEnabled = true;
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()));
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: NSStringFromClass(UICollectionReusableView.classForCoder()), withReuseIdentifier:NSStringFromClass(UICollectionReusableView.classForCoder()));
        collectionView.backgroundColor = Appxf8f8f8;
        collectionView.backgroundView?.backgroundColor = Appxf8f8f8;
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView);
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
}
extension BaseConnectionController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 0, height: 0);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()), for: indexPath);
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
