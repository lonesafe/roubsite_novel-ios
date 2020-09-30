//
//  GKHomeController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKHomeController: BaseConnectionController,KLRecycleScrollViewDelegate {
    private var options : GKLoadOptions = .None
    private lazy var homeNet : GKHomeNet = {
        let net : GKHomeNet = GKHomeNet();
        return net;
    }()
    private lazy var listData: [GKHomeInfo] = {
        return []
    }()
    private lazy var navBarView: GKHomeNavBarView = {
        let user :GKUserModel = GKUserManager.getModel()
        let view = GKHomeNavBarView.instanceView();
        view.chirdenBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside);
        return view ;
    }()
    private lazy var recyleView : KLRecycleScrollView = {
        let recyleView :KLRecycleScrollView = KLRecycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-120, height: 30))
        recyleView.timerEnabled = true;
        recyleView.pagingEnabled = true;
        recyleView.scrollInterval = 4;
        recyleView.direction = KLRecycleScrollViewDirection.top;
        recyleView.delegate = self;
        return recyleView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI();
        self.loadData();
    }
    private func loadUI(){
        self.options = GKLoadOptions.Default;
        self.fd_prefersNavigationBarHidden = true;
        self.navBarView.backgroundColor = AppColor;
        self.view.addSubview(self.navBarView);
        self.navBarView.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.height.equalTo(NAVI_BAR_HIGHT);
        }
        self.collectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp_bottom);
            make.left.right.bottom.equalToSuperview();
        }
        self.navBarView.tapView.addSubview(self.recyleView);
        self.recyleView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.recyleView.reloadData(appDatas.count);
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .defaults);
        
    }
    private func loadData(){
        GKHomeNet.reloadHomeDataNeed { (options) in
            self.options = options;
            self.refreshData(page: 1);
        }
    }
    override func refreshData(page: Int) {
        self.navBarView.reloadUI();
        self.homeNet.homeNet(options:self.options, sucesss: { (object) in
            self.listData = object ;
            self.collectionView.reloadData();
            self.endRefresh(more: false);
        }) { (error) in
            self.endRefreshFailure();
        }
    }
    @objc private func moreAction(sender:UIButton) {
        let bookInfo :GKHomeInfo = self.listData[sender.tag];
        switch bookInfo.state {
        case .DataNet?:
            GKJump.jumpToMore(homeInfo: bookInfo);
            break
        default:
            let info : Any = bookInfo.listData.first as Any;
            if info is GKBookModel{
                GKJump.jumpToBookCase();
            }else{
                
            }
            break
        }
    }
    @objc private func selectAction(){
        let vc = GKSexViewController.init();
        let nvc = BaseNavigationController.init(rootViewController: vc);
        nvc.modalPresentationStyle = .fullScreen;
        UIViewController.rootTopPresentedController().present(nvc, animated:false, completion: nil);
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let bookInfo :GKHomeInfo = self.listData[section];
        return bookInfo.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 40);
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view :GKHomeReusableView = GKHomeReusableView.viewForCollectionView(collectionView: collectionView, elementKind: kind, indexPath: indexPath);
        view.moreBtn.tag = indexPath.section;
        view.moreBtn.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        let bookInfo :GKHomeInfo = self.listData[indexPath.section];
        view.titleLab.text = bookInfo.shortTitle ?? "";
        view.moreBtn.isHidden = !bookInfo.moreData;
        return view;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 60 - 1)/3.0;
        let height = width * 1.35 + 50;
        return CGSize.init(width: width, height: height);
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GKBookCell = GKBookCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        let bookInfo :GKHomeInfo = self.listData[indexPath.section];
        cell.model = bookInfo.listData[indexPath.row];
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookInfo :GKHomeInfo = self.listData[indexPath.section];
        
        let model:GKBookModel = bookInfo.listData[indexPath.row];
        switch bookInfo.state {
        case .DataNet?:
            GKJump.jumpToDetail(bookId: model.bookId!)
            break
        default:
            GKJump.jumpToNovel(bookModel: model);
            break
            
        }
    }
    func recycleScrollView(_ recycleScrollView: KLRecycleScrollView!, viewForItemAt index: Int) -> UIView! {
        let label : UILabel = UILabel.init();
        label.font = UIFont.systemFont(ofSize: 14);
        label.textColor = UIColor.init(hex: "666666");
        label.text = appDatas[index];
        return label;
    }
    func recycleScrollView(_ recycleScrollView: KLRecycleScrollView!, didSelect view: UIView!, forItemAt index: Int) {
        GKJump.jumpToSearch()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
}
