//
//  GKNovelSetView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
@objc protocol GKNovelSetDelegate : NSObjectProtocol{
    @objc optional func changeFont(setView:GKNovelSetView);
    @objc optional func changeRead(setView:GKNovelSetView);
    @objc optional func changeSkin(setView:GKNovelSetView);
}
class GKNovelSetView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    weak var delegate:GKNovelSetDelegate?;
    lazy var listData : [String] = {
        return GKNovelSetManager.themes();
    }()
    lazy var buttonDatas: [UIButton] = {
        return [self.leftBtn,self.centerBtn,self.rightBtn];
    }()
    lazy var colletionView : UICollectionView = {
        var layout :UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        var collection : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout:layout);
        collection.showsHorizontalScrollIndicator = false;
        collection.dataSource = self;
        collection.delegate = self;
        return collection;
    }()
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var reduceBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var fontLab: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var centerBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.setThumbImage(UIImage.init(named: "icon_slider"), for: .normal)
        self.isUserInteractionEnabled = true
        self.colletionView.backgroundView?.backgroundColor = UIColor.white
        self.colletionView.backgroundColor = UIColor.white
        self.addSubview(self.colletionView)
        self.colletionView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalTo(self.leftBtn.snp_bottom).offset(15)
            make.height.equalTo(60)
        }
        
        self.leftBtn.layer.masksToBounds = true
        self.centerBtn.layer.masksToBounds = true;
        self.rightBtn.layer.masksToBounds = true;
        
        self.leftBtn.layer.cornerRadius = 5;
        self.centerBtn.layer.cornerRadius = 5
        self.rightBtn.layer.cornerRadius = 5;

        
        self.reduceBtn.layer.masksToBounds = true;
        self.reduceBtn.layer.cornerRadius = 5;
        self.reduceBtn.layer.borderWidth = 1.0
        self.reduceBtn.layer.borderColor = UIColor.init(hex: "999999").cgColor;
        
        self.addBtn.layer.masksToBounds = true;
        self.addBtn.layer.cornerRadius = 5;
        self.addBtn.layer.borderWidth = 1.0
        self.addBtn.layer.borderColor = UIColor.init(hex: "999999").cgColor;

        self.loadData();
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        let bright :Float = sender.value;
        UIScreen.main.brightness = CGFloat(bright);
    }
    @IBAction func reduceAction(_ sender: UIButton) {
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if Int(model.font) <= 10{
            MBProgressHUD.showMessage("最大字体为10");
            return;
        }
        let font : Int = Int(model.font) - 2
        GKNovelSetManager.setFont(font: Float(font));
        self.fontLab.text = String(font)+"px";
        if let myDelegate = self.delegate {
            myDelegate.changeFont?(setView: self);
        }
    }
    @IBAction func addAction(_ sender: UIButton) {
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        if Int(model.font) >= 30{
            MBProgressHUD.showMessage("最大字体为30");
            return;
        }
        let font : Int = Int(model.font) + 2
        GKNovelSetManager.setFont(font: Float(font));
        self.fontLab.text = String(font)+"px";
        if let myDelegate = self.delegate {
            myDelegate.changeFont?(setView: self)
        }
    }
    
    @IBAction func leftAction(_ sender: UIButton) {
        GKNovelSetManager.setBrowse(browse: .defaults);
        if let myDelegate = self.delegate {
            myDelegate.changeRead?(setView: self)
        }
        self.changeButtonState();
    }
    
    @IBAction func centerAction(_ sender: UIButton) {
        GKNovelSetManager.setBrowse(browse: .pageCurl);
        if let myDelegate = self.delegate {
            myDelegate.changeRead?(setView: self)
        }
        self.changeButtonState();
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        GKNovelSetManager .setBrowse(browse: .none)
        if let myDelegate = self.delegate {
            myDelegate.changeRead?(setView: self)
        }
        self.changeButtonState();
    }
    func loadData(){
        let model : GKNovelSet = GKNovelSetManager.manager.config!
        let bright :Float = Float(UIScreen.main.brightness);
        self.slider.value = bright;
        self.fontLab.text = String(model.font)+"px";
        self.changeButtonState();
        self.colletionView.reloadData();
    }
    func changeButtonState(){
        let model :GKNovelSet = GKNovelSetManager.manager.config!
        var index = 0;
        for obj in self.buttonDatas {
            let button : UIButton = obj as UIButton;
            button.layer.masksToBounds = true;
            button.layer.cornerRadius = 3;
            if model.browse.rawValue == index{
                button.setTitleColor(UIColor.white, for: .normal);
                button.backgroundColor = AppColor;
            }else{
                button.setTitleColor(UIColor.init(hex: "333333"), for: .normal);
                button.backgroundColor = UIColor.init(hex: "eeeeee");
            }
            index  = index + 1;
        }
    }
    //UICollectionViewDelegate,UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width:60, height: 60);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : GKNovelSetCell  = GKNovelSetCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let model : String = self.listData[indexPath.row];
        let skin : GKNovelSet = GKNovelSetManager.manager.config!
        cell.imageV.image = UIImage.init(named: model)
        cell.icon.isHidden = !(model == skin.skin.rawValue)
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model : String = self.listData[indexPath.row];
        let skin : GKNovelSet = GKNovelSetManager.manager.config!
        if model == skin.skin.rawValue {
            return
        }
        GKNovelSetManager.setSkin(skin:GKNovelTheme(rawValue: model)!)
        if let myDelegate = self.delegate {
            myDelegate.changeSkin?(setView: self)
        }
        self.colletionView.reloadData();


    }
    
}
