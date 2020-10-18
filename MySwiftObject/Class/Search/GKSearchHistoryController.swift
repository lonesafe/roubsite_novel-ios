//
//  GKSearchHistoryController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import ATRefresh_Swift
private let width = (SCREEN_WIDTH - 60)/3.0;
private let height = width * 1.35 + 50 + 50 + 30;
class GKSearchHistoryController: BaseTableViewController,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    lazy var tableHeadView : UIView = {
        return UIView.init();
    }()
    lazy var info : GKHomeInfo = {
        return GKHomeInfo()
    }()
    lazy var listData : [String] = {
        return [];
    }()
    lazy var collectionView : UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .horizontal;
        let collectionView : UICollectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: layout);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.isScrollEnabled = true;
        collectionView.backgroundColor = UIColor.white;
        collectionView.backgroundView?.backgroundColor = UIColor.white;
        return collectionView
    }()
    lazy var searchView : GKSearchTopView = {
        let searchView : GKSearchTopView = GKSearchTopView.init()
        searchView.textField.delegate = self;
        searchView.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside);
        return searchView;
    }()
    lazy var headView : GKSearchHeadView = {
        let headView : GKSearchHeadView = GKSearchHeadView.init()
        headView.backgroundColor = UIColor.white;
        headView.titleLab.text = "历史记录";
        headView.deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside);
        return headView;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableHeadView.backgroundColor = UIColor.white;
        self.fd_interactivePopDisabled = true;
        self.fd_prefersNavigationBarHidden = true;
        self.view.addSubview(self.searchView);
        self.searchView.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.height.equalTo(BaseMacro.init().NAVI_BAR_HIGHT);
        }
        self.tableView.snp_remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.searchView.snp_bottom);
        }
        self.tableView.backgroundColor = Appxffffff
        self.setupEmpty(scrollView: self.tableView, image: nil, title: "History Data Empty...")
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
        if self.searchView.textField.canBecomeFirstResponder {
            self.searchView.textField.becomeFirstResponder();
        }
        let title = GKSearchHeadView.init();
        title.titleLab.text = "最热搜索";
        title.deleteBtn.isHidden = true;
        self.tableHeadView.addSubview(title);
        title.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.height.equalTo(50);
        }
        self.tableHeadView.addSubview(self.collectionView);
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(title.snp_bottom);
        }
        self.tableHeadView.isHidden = true;
    }
    @objc func backAction(){
        self.back(animated: false)
    }
    @objc func deleteAction(){
        ATAlertView.showAlertView(title: "确定删除所有历史记录", message: "", normals: ["取消"], hights: ["确定"]) { (title , index) in
            if index > 0{
                GKBookSearchDataQueue.deleteKeyWord(datas: self.listData, completion: { (success) in
                    if success{
                        self.listData.removeAll();
                        self.tableView.reloadData();
                    }
                })
            }
        }
    }
    func searchTextField(keyWork :String){
        let texts : String = keyWork.trimmingCharacters(in: .whitespaces);
        self.inseartData(keyWork: texts);
        GKJump.jumpToSearchResult(keyWord: keyWork);
        
    }
    func inseartData(keyWork :String){
        GKBookSearchDataQueue.insertKeyWord(keyWord: keyWork) { (success) in
            if success{
                self.headerRefreshing();
            }
        }
    }
    override func refreshData(page: Int) {
        var list : [ String] = [];
        let group : DispatchGroup = DispatchGroup.init();
        if page == 1 {
            group.enter();
            RoubSiteBlockNet.getBlockNovelInfo(blockId:"5a6844aafc84c2b8efaa6b6e", sucesss: { (object) in
                if let info : GKHomeInfo = GKHomeInfo.deserialize(from: object["ranking"].rawString()){
                    self.info = info;
                }
                group.leave()
            }) { (error) in
                group.leave()
            }
        }
        group.enter();
        GKBookSearchDataQueue.getKeyWords(page: page, size: NSInteger(30)) { (datas) in
            list = datas;
            if page == 1{
                self.listData.removeAll();
            }
            if datas.count > 0{
                self.listData.append(contentsOf:datas);
            }
            group.leave()
        }
        group.notify(queue:DispatchQueue.main) {
            self.tableHeadView.isHidden = self.info.books.count == 0;
            self.tableHeadView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.info.books.count == 0 ? 0.1 :height);
            self.tableView.tableHeaderView = self.tableHeadView;
            self.collectionView.reloadData();
            self.tableView.reloadData();
            self.endRefresh(more: list.count >= 30);
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            textField.resignFirstResponder();
            return false;
        }
        self.searchTextField(keyWork:textField.text!);
        return true;
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.info.books.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 60)/3.0;
        let height = width * 1.35 + 50;
        return CGSize.init(width: width, height: height);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GKBookCell = GKBookCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.info.books[indexPath.row];
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model : GKBookModel = self.info.books[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId!);
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GKSearchHistoryCell = GKSearchHistoryCell.cellForTableView(tableView: tableView, indexPath: indexPath) ;
        cell.titleLab.text = self.listData[indexPath.row];
        return cell;
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.listData.count > 0 ? 40 : 0.001;
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headView.isHidden = self.listData.count == 0;
        return self.headView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        GKJump.jumpToSearchResult(keyWord:self.listData[indexPath.row]);
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row : UITableViewRowAction = UITableViewRowAction.init(style: .default, title: "删除") { (row, inde) in
            GKBookSearchDataQueue.deleteKeyWord(keyWord: self.listData[indexPath.row], completion: { (success) in
                if success{
                    if self.listData.count > indexPath.row{
                        self.listData.remove(at: indexPath.row)
                        self.tableView.reloadData();
                    }
                }
            });
        }
        return [row];
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return self.info.listData.count > 0 ? height/2 : 0.001;
    }
}
