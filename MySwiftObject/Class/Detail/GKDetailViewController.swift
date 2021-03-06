//
//  GKDetailViewController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class GKDetailViewController: YNPageViewController, YNPageViewControllerDelegate, YNPageViewControllerDataSource {
    class func vcWithBookId(bookId: String) -> Self {
        let config = YNPageConfigration.defaultConfig();
        config?.headerViewCouldScale = true;
        config?.scrollMenu = true;
        config?.showNavigation = false;
        config?.showTabbar = true;
        config?.pageStyle = .suspensionCenter;
        config?.headerViewScaleMode = .top;
        config?.aligmentModeCenter = true;
        config?.selectedItemColor = AppColor;
        config?.selectedItemFont = UIFont.systemFont(ofSize: 17);
        config?.itemFont = UIFont.systemFont(ofSize: 15)
        config?.menuHeight = 44;
        config?.itemMargin = 40;
        config?.lineColor = AppColor;
        config?.normalItemColor = Appx333333;
        config?.suspenOffsetY = BaseMacro.init().STATUS_BAR_HIGHT;
        config?.lineWidthEqualFontWidth = true;
        let vc: GKDetailViewController = GKDetailViewController.init(controllers: [GKCenterController.vcWithBookId(bookId: bookId), GKChapterController.vcWithBookId(bookId: bookId)], titles: ["推荐", "章节"], config: config);
        vc.delegate = vc;
        vc.dataSource = vc;
        vc.headerView = vc.topView;
        vc.bookId = bookId;
        return vc as! Self;
    }

    private lazy var topView: GKDetailTopView = {
        let topView: GKDetailTopView = GKDetailTopView.instanceView();
        topView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 150 + BaseMacro.init().NAVI_BAR_HIGHT);
        topView.backAction.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        return topView;
    }()
    private lazy var tabView: GKDetailTabView = {
        let tab: GKDetailTabView = GKDetailTabView.instanceView();
        tab.favBtn.addTarget(self, action: #selector(favAction(sender:)), for: .touchUpInside)
        tab.readBtn.addTarget(self, action: #selector(readAction), for: .touchUpInside);
        return tab;
    }()
    private lazy var backBtn: UIButton = {
        var backBtn = UIButton.init(type: .custom);
        backBtn.setImage(UIImage.init(named: "icon_detail_back"), for: .normal);
        backBtn.addTarget(self, action: #selector(goBackAction), for: .touchUpInside);
        return backBtn;
    }()
    private var bookId: String! = nil
    private var height: CGFloat = 0;
    private var model: GKBookDetailModel = GKBookDetailModel() {
        didSet {
            let item: GKBookDetailModel = model;
            self.topView.model = item;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI();
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GKBookCaseDataQueue.getBookModel(bookId: self.bookId) { (model) in
            self.tabView.favBtn.isSelected = model.bookId!.count > 0 ? true : false;

        }
    }

    private func loadUI() {
        self.fd_prefersNavigationBarHidden = true;
        self.view.addSubview(self.tabView);
        self.tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.height.equalTo(49)
            make.bottom.equalToSuperview().offset(-BaseMacro.init().TAB_BAR_ADDING);
        }
    }

    @objc private func readAction() {
        if let model: GKBookModel = GKBookModel.deserialize(from: self.model.toJSONString()) {
            GKJump.jumpToNovel(bookModel: model);
        }
    }

    @objc private func favAction(sender: UIButton) {
        if self.model.bookId!.count == 0 {
            return;
        }
        if let model: GKBookModel = GKBookModel.deserialize(from: self.model.toJSONString()) {
            if sender.isSelected == false {
                GKBookCaseDataQueue.insertBookModel(bookDetail: model) { (success) in
                    if success {
                        self.tabView.favBtn.isSelected = true;
                        MBProgressHUD.showMessage("已添加到书架");
                    }
                }
            } else {
                ATAlertView.showAlertView(title: "是否从书架中移出？", message: "", normals: ["取消"], hights: ["确定"]) { (title, index) in
                    if index > 0 {
                        GKBookCaseDataQueue.deleteBookModel(bookId: self.bookId, sucesss: { (success) in
                            if success {
                                MBProgressHUD.showMessage("移出成功");
                                self.tabView.favBtn.isSelected = false;
                            }
                        })
                    }
                }
            }
        }
    }

    @objc private func goBackAction() {
        self.goBack();
    }

    private func loadData() {
        RoubSiteNovelClassifyNet.bookDetail(bookId: self.bookId, sucesss: { (object) in
            if ("1" == object["status"]) {
                let novelInfo: JSON = object["data"];
                var model: GKBookDetailModel = GKBookDetailModel.init();
                model.size = novelInfo["SIZE"].intValue;
                model.wordCount = novelInfo["SIZE"].intValue;
                if ("1" == novelInfo["IS_VIP"].stringValue) {
                    model.vip = true;
                }
                var updateTime = Int(novelInfo["LAST_UPDATE_TIME"].stringValue)!;
                model.updateTime = TimeInterval.init(updateTime);
                model.title = novelInfo["NOVEL_NAME"].stringValue;
                model.shortIntro = novelInfo["NOVEL_SUMMARY"].stringValue;
                model.lastChapter = novelInfo["LAST_CHAPTER_NAME"].stringValue;
                model.cover = novelInfo["NOVEL_IMAGE"].stringValue;
                model.bookId = novelInfo["NOVEL_ID"].stringValue;
                model.author = novelInfo["AUTHOR_NAME"].stringValue;
                if (novelInfo["STATUS"]=="0"){
                    model.isNotEnd = true;
                }
                self.model = model;
            }
        }) { (error) in

        }
    }

    func pageViewController(_ pageViewController: YNPageViewController!, pageFor index: Int) -> UIScrollView! {
        let vc: UIViewController = pageViewController.controllersM![index] as! UIViewController;
        if vc is BaseTableViewController {
            let ctrl: BaseTableViewController = vc as! BaseTableViewController
            return ctrl.tableView;
        } else if vc is BaseConnectionController {
            let ctrl: BaseConnectionController = vc as! BaseConnectionController
            return ctrl.collectionView;
        }
        return UIScrollView.init()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
