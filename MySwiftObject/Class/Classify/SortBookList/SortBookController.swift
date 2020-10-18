import UIKit
import SwiftyJSON

class SortBookController: BaseViewController, VTMagicViewDelegate, VTMagicViewDataSource {
    private var typesKey: [String] = ["ALL_VISIT", "CREATE_TIME", "STATUS"];
    private var typesName: [String] = ["热度", "最新", "全本"];
    private var sortId: String!;
    private var name: String!;

    convenience init(sortId: String, name: String) {
        self.init();
        self.sortId = sortId;
        self.name = name;
    }

    private lazy var magicViewCtrl: VTMagicController = {
        let ctrl = VTMagicController.init();
        ctrl.magicView.navigationInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        ctrl.magicView.separatorHeight = 0.5;
        ctrl.magicView.backgroundColor = Appxffffff
        ctrl.magicView.separatorColor = UIColor.clear;
        ctrl.magicView.navigationColor = Appxffffff;
        ctrl.magicView.switchStyle = .default;

        ctrl.magicView.sliderColor = AppColor
        ctrl.magicView.sliderExtension = 1;
        ctrl.magicView.bubbleRadius = 1;
        ctrl.magicView.sliderWidth = 30;

        ctrl.magicView.layoutStyle = .default;
        ctrl.magicView.navigationHeight = 30;
        ctrl.magicView.sliderHeight = 2;
        ctrl.magicView.itemSpacing = 20;

        ctrl.magicView.isAgainstStatusBar = false;
        ctrl.magicView.dataSource = self;
        ctrl.magicView.delegate = self;
        ctrl.magicView.itemScale = 1.15;
        ctrl.magicView.needPreloading = true;
        ctrl.magicView.bounces = false;
        return ctrl
    }()

    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = self.name
        self.loadUI()
    }

    private func loadUI() {
        self.fd_prefersNavigationBarHidden = false;
        self.addChild(self.magicViewCtrl);
        self.view.addSubview(self.magicViewCtrl.view);
        self.magicViewCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.magicViewCtrl.magicView.reloadData();
    }

    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.typesName;
    }

    func magicView(_ magicView: VTMagicView, menuItemAt: UInt) -> UIButton {
        let button: UIButton = magicView.dequeueReusableItem(withIdentifier: "com.new.btn.itemIdentifier") ?? UIButton.init();
        button.setTitle(self.typesName[Int(menuItemAt)], for: .normal);
        button.setTitleColor(Appx333333, for: .normal);
        button.setTitleColor(AppColor, for: .selected);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular);
        return button;
    }

    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let vc: SortBookListController = SortBookListController(sortId: sortId, name: name, type: self.typesKey[Int(pageIndex)])
        vc.hidesBottomBarWhenPushed = true;
//        let vc = (magicView.dequeueReusablePage(withIdentifier: "com.new.btn.itemIdentifier")) ?? SortBookListController()
//        let ctrl: SortBookListController = vc as! SortBookListController
//        ctrl.parentSortId = self.typesName[Int(pageIndex)]
        return vc
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default;
    }

}
