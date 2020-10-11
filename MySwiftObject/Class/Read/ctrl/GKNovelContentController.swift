//
//  GKContentController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import AVFoundation
class GKNovelContentController: BaseViewController{
    
    convenience init(bookModel : GKBookModel) {
        self.init();
        self.bookModel = bookModel;
    }

    private var pageCtrl  :UIPageViewController!
    private var covelCtrl :DZMCoverController!
    private var bookModel :GKBookModel!
//    private var source    :GKNovelSource!
    private var chapterInfo:GKNovelChapterInfo!
    private var content    :GKNovelContent!
    
    private var chapter    :NSInteger = 0
    private var pageIndex  :NSInteger = 0
    private var volice     :Float = 0
    
    lazy var tapView : GKNovelTapView = {
        let tap : GKNovelTapView = GKNovelTapView.init()
        tap.setView.delegate = self
        tap.topView.delegate = self
        tap.bottomView.delegate = self
        tap.directoryView.delegate = self
        return tap
    }()
    private var turnPage : Bool?{
        get{
            let set :GKNovelSet = GKNovelSetManager.manager.config!
            return set.browse == GKNovelBrowse.pageCurl
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        loadUI()
        loadData()
    }
    func loadUI(){
        self.fd_interactivePopDisabled = true
        self.fd_prefersNavigationBarHidden = true
        self.view.addSubview(self.tapView)
        self.tapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)));
        tap.delegate = self;
        self.view.addGestureRecognizer(tap);
        self.turnPage! ? loadPageCtrlUI() : loadCovelCtrlUI()
    }

    @objc func tapAction(sender:UITapGestureRecognizer){
        
        let point : CGPoint = sender.location(in:self.view);
        if point.x > SCREEN_WIDTH/3.0 && point.x < SCREEN_WIDTH/3.0*2 {
            if self.tapView.isHidden  {
                self.tapView.showTapAction()
            }
        }
    }
    func nextAction(){
        let listData = self.chapterInfo.chapters;
        if self.chapter + 1 >= listData.count {
            MBProgressHUD.showMessage("已经是最后一章");
            return;
        }
        self.chapter = self.chapter + 1;
        self.pageIndex = 0;
        self.bookContent(chapter: self.chapter);
        
    }
    func lastAction(){
        if self.chapter == 0 {
            MBProgressHUD.showMessage("已经是第一章");
            return;
        }
        self.chapter = self.chapter - 1;
        self.pageIndex = 0;
        self.bookContent(chapter: self.chapter);
    }
    func loadData(){
        GKBrowseDataQueue.getBookModel(bookId: self.bookModel.bookId!) { (model) in
            if model.bookId == nil || model.chapterInfo == nil{
                self.bookSummary();
            }else{
                self.chapter = model.chapter!;
                self.pageIndex = model.pageIndex!;
//                self.source = model.source;
                self.chapterInfo = model.chapterInfo;
                self.bookContent(chapter: self.chapter)
            }
        }
        let set :GKNovelSet = GKNovelSetManager.manager.config!
        self.tapView.bottomView.dayBtn.isSelected = set.night;
        self.tapView.topView.titleLab.text = self.bookModel.title ?? "";
        GKBookCaseDataQueue.getBookModel(bookId: self.bookModel.bookId!) { (model) in
            self.tapView.topView.favBtn.isSelected = model.bookId!.count > 0 ? true : false;
        }
        
    }
    func bookSummary(){
//        GKNovelNet.bookSummary(bookId:self.bookModel.bookId!, sucesss: { (source) in
//            self.source = source;
            self.bookChapters()
//        }) { (error) in
//            self.showEmptyTitle(title: error);
//        };
    }
    func bookChapters(){
        RoubSiteNovelNet.bookChapters(bookId: self.bookModel.bookId!, sucesss: { (object) in
            self.chapterInfo = object;
            self.bookContent(chapter: 0)
        }) { (error) in
            self.showEmptyTitle(title: error);
        };
    }
    func bookContent(chapter:NSInteger){
        let info :GKNovelChapter = self.chapterInfo.chapters[chapter];
        RoubSiteNovelNet.bookContentModel(bookId:self.bookModel.bookId!, model: info, sucesss: { (content) in
            self.content = content;
            self.reloadUI()
        }) { (error) in
            self.showEmptyTitle(title: error);
        }
    }
    func showEmptyTitle(title:String){
        let vc:GKNovelItemController = self.readCtrl!
        vc.emptyData(empty:true);
        if self.turnPage! {
            self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil);
        }else{
            self.covelCtrl.setController(vc);
        }
    }
    func removePageCtrlUI(){
        if (self.pageCtrl != nil) {
            self.pageCtrl.view.removeFromSuperview();
            self.pageCtrl.removeFromParent();
            self.pageCtrl.dataSource = nil;
            self.pageCtrl.delegate = nil;
            self.pageCtrl = nil;
        }
    }
    func loadPageCtrlUI(){
        self.removePageCtrlUI();
        self.removewCovelCtrlUI()
        let vc :UIViewController = GKNovelItemController.init();
        self.pageCtrl = UIPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageCtrl.dataSource = self;
        self.pageCtrl.delegate = self;
        self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil);
        self.addChild(self.pageCtrl);
        self.view.addSubview(self.pageCtrl.view);
        self.view.sendSubviewToBack(self.pageCtrl.view);
        self.pageCtrl.didMove(toParent: self);
        self.pageCtrl.view.snp_makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    func removewCovelCtrlUI(){
        if (self.covelCtrl != nil) {
            self.covelCtrl.view.removeFromSuperview();
            self.covelCtrl.removeFromParent();
            self.covelCtrl.delegate = nil;
            self.covelCtrl = nil;
        }
    }
    func loadCovelCtrlUI(){
        let model :GKNovelSet = GKNovelSetManager.manager.config!
        self.removePageCtrlUI();
        self.removewCovelCtrlUI()
        let vc :UIViewController = GKNovelItemController.init();
        self.covelCtrl = DZMCoverController.init()
        self.covelCtrl.setController(vc);
        self.covelCtrl.delegate = self;
        self.covelCtrl.openAnimate = (model.browse == .defaults);
        self.addChild(self.covelCtrl);
        self.view.addSubview(self.covelCtrl.view);
        self.view.sendSubviewToBack(self.covelCtrl.view);
        self.covelCtrl.didMove(toParent: self);
        self.covelCtrl.view.snp_makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    func reloadUI(){
        self.content.pageContent()
        self.turnPage! ? self.reloadPageCtrlUI():self.reloadCovelCtrlUI()
        
        self.tapView.content = self.content
        self.tapView.bottomView.slider.value = Float(self.pageIndex)
        self.tapView.directoryView.setDatas(listData: self.chapterInfo.chapters)
        self.tapView.directoryView.chapter = self.chapterInfo.chapters[self.chapter]
        
    }
    func reloadPageCtrlUI(){
        self.pageCtrl.setViewControllers([self.readCtrl!], direction: .forward, animated: false, completion: nil);
    }
    func reloadCovelCtrlUI(){
        self.covelCtrl.setController(self.readCtrl)
    }
    @objc func buttonAction(){
        self.pageIndex = 0;
        self.bookContent(chapter:self.chapter);
    }
    func leftAction(){
        let vc:UIViewController = self.beforeCtrl!
        if self.turnPage! {
            self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }else{
            self.covelCtrl.setController(vc)
        }
    }
    func rightAction(){
        let vc:UIViewController = self.afterCtrl!
        if self.turnPage! {
            self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }else{
            self.covelCtrl.setController(vc)
        }
    }

    func currentCtrl(ctrl:GKNovelItemController) {
        if self.pageIndex != ctrl.pageIndex {
            self.pageIndex = ctrl.pageIndex
        }
        if self.chapter != ctrl.chapter {
            self.chapter = ctrl.chapter
            self.getNovelContent(chapter: self.chapter)
        }
    }
    var beforeCtrl :GKNovelItemController?{
        get{
            let vc :GKNovelItemController = self.showCtrl!
            if self.pageIndex <= 0 && self.chapter <= 0 {
                MBProgressHUD.showMessage("当前第一章，第一页")
                self.chapter = 0
                self.pageIndex = 0
                return nil
            }else if(self.pageIndex <= 0){
                if vc.chapter == self.chapter{
                    self.chapter  = self.chapter - 1;
                    self.getNovelContent(chapter: self.chapter);
                    self.pageIndex = self.content.pageCount - 1;
                }
            }else{
                if vc.pageIndex == self.pageIndex{
                    self.pageIndex = self.pageIndex - 1;
                }
            }
            return self.readCtrl!
        }
    }
    var afterCtrl : GKNovelItemController?{
        get{
            if self.content != nil {
                let vc :GKNovelItemController = self.showCtrl!
                let chapters :[GKNovelChapter] = self.chapterInfo!.chapters
                if self.pageIndex >= self.content.pageCount - 1 && self.chapter >= chapters.count {
                    MBProgressHUD.showMessage("当前最后一章，最后一页")
                    return nil
                }else if(self.pageIndex >= self.content.pageCount - 1){
                    if vc.chapter == self.chapter{
                        self.chapter = self.chapter + 1;
                        self.getNovelContent(chapter: self.chapter);
                        self.pageIndex = 0;
                    }
                }else{
                    if(vc.pageIndex == self.pageIndex){
                        self.pageIndex = self.pageIndex + 1;
                    }
                }
                return self.readCtrl!
            }
            return nil
        }
    }
    var readCtrl :GKNovelItemController?{
        get{
            let vc:GKNovelItemController = GKNovelItemController()
            vc.tryButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside);
            if self.content != nil{
                self.getBeforeData();
                self.getAfterData();
                vc.setModel(model:self.content, chapter: self.chapter, pageIndex: self.pageIndex);
                self.tapView.bottomView.slider.value = Float(self.pageIndex)
            }
            return vc;
        }
    }
    var showCtrl :GKNovelItemController?{
        get{
            let vc  = (self.turnPage! ? self.pageCtrl.viewControllers?.first: self.covelCtrl!.currentController)as! GKNovelItemController
            return vc;
        }
    }
    func getBeforeData(){
        let chapterData : [GKNovelChapter] = self.chapterInfo!.chapters
        let chapter:NSInteger = self.chapter - 1;
        if chapter >= 0 && chapterData.count > chapter {
            let info:GKNovelChapter = chapterData[chapter] ;
            RoubSiteNovelNet.bookContentModel(bookId:self.bookModel.bookId!, model: info, sucesss: { (content) in
                GKCache.set(object: content.toJSON()!, key: info.chapterId)
            }) { (error) in
                
            }
        }
    }
    func getAfterData(){
        if self.content.pageCount > 0 {
            let chapterData :[GKNovelChapter] = self.chapterInfo!.chapters
            let chapter:NSInteger = self.chapter + 1;
            if self.content.pageCount > self.pageIndex && chapterData.count > chapter {
                let info:GKNovelChapter = chapterData[chapter]
                RoubSiteNovelNet.bookContentModel(bookId:self.bookModel.bookId!, model: info, sucesss: { (content) in
                    GKCache.set(object: content.toJSON()!, key: info.chapterId)
                }) { (error) in
                    
                }
            }
        }
    }
    func getNovelContent(chapter:NSInteger){
        let chapters:[GKNovelChapter] = self.chapterInfo.chapters;
        let info:GKNovelChapter = chapters[chapter];
        self.content = info.content;
        if info.chapterId.count == 0{
            let content :GKNovelContent = GKNovelContent.init();
            content.content = "更多精彩内容请耐心等待...";
            self.content = content;
        }
        self.content.pageContent()
    }
    func inseDataQueue(){
        let model:GKBrowseModel = GKBrowseModel.init();
        model.bookId = self.bookModel.bookId;
        model.chapter = self.chapter;
        model.pageIndex = self.pageIndex;
        model.chapterInfo = self.chapterInfo;
//        model.source = self.source;
        model.bookModel = self.bookModel;
        GKBrowseDataQueue.insertBookModel(browse: model) { (success) in
            
        }
    }
    override var prefersStatusBarHidden: Bool{
        return self.tapView.isHidden
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        print(NSStringFromClass(touch.view!.classForCoder))
        let str:String = NSStringFromClass(touch.view!.classForCoder)
        let view : UIView = touch.view!;
        if str.elementsEqual("UITableViewCellContentView") {
            return false;
        }
        if view.tag == 10086 {
            return false;
        }
        return true;
    }
}
extension GKNovelContentController : GKTopDelegate{
    func topView(topView : GKNovelTopView,back : Bool){
        self.goBack();
        DispatchQueue.global().async {
            self.inseDataQueue();
        };
        GKCache.removeAll()
    }
    func topView(topView : GKNovelTopView,fav  : Bool){
        if !fav {
            GKBookCaseDataQueue.deleteBookModel(bookId:self.bookModel.bookId!) { (success) in
                
            }
        }else{
            GKBookCaseDataQueue.insertBookModel(bookDetail: self.bookModel) { (success) in
                
            }
        }
    }
}
extension GKNovelContentController : GKNovelSetDelegate{
    func changeFont(setView: GKNovelSetView) {
        self.reloadUI();
    }
    func changeRead(setView: GKNovelSetView) {
        if self.turnPage! {
            self.loadPageCtrlUI()
        }else{
            self.loadCovelCtrlUI();
        }
        self.reloadUI()
    }
    func changeSkin(setView: GKNovelSetView) {
        self.reloadUI()
    }
}
extension GKNovelContentController : GKBottomDelegate{
    func bottomView(bottomView :GKNovelTabView,last   :Bool){
        last ? lastAction() : nextAction();
    }
    func bottomView(bottomView :GKNovelTabView,day    :Bool){
        GKNovelSetManager.setNight(night: day)
        self.reloadUI();
    }
    func bottomView(bottomView :GKNovelTabView,slider :Int){
        self.pageIndex = slider
        self.reloadUI()
    }
}
extension GKNovelContentController : GKNovelDirectoryDelegate{
    func selectChapter(view :GKNovelDirectoryView, chapter:NSInteger){
        self.chapter = chapter
        self.pageIndex = 0
        self.bookContent(chapter:self.chapter)
        self.tapView.tapAction()
    }
}
extension GKNovelContentController : DZMCoverControllerDelegate{
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        self.currentCtrl(ctrl:currentController as! GKNovelItemController);
    }
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return self.beforeCtrl
    }
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return self.afterCtrl
    }
}
extension GKNovelContentController : UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc:GKNovelItemController = self.pageCtrl.viewControllers?.first as! GKNovelItemController
        self.currentCtrl(ctrl:vc);
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.beforeCtrl!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.afterCtrl!
    }
    internal func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        let vc = pageViewController.viewControllers?.first
        if (vc != nil) {
            self.pageCtrl.setViewControllers([vc!], direction: .forward, animated: true, completion: nil);
            return .min;
        }
        return.none;
    }
}
