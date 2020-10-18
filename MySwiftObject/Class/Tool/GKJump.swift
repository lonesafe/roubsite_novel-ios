//
//  GKJump.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKJump: NSObject {
    class func jumpToGuideCtrl(completion:((() -> Void))? = nil){
        let user :GKUserModel = GKUserManager.getModel()
        if (user.rankDatas.count == 0) {
            GKJump.window().rootViewController = GKSexViewController(completion: completion);
        }else{
            if completion != nil {
                completion!();
            }
        }
        GKJump.jumpToLaunchController();
    }
    class func jumpToDetail(bookId:String){
        let vc : GKDetailViewController = GKDetailViewController.vcWithBookId(bookId: bookId) ;
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true);
    }
    class func jumpToMore(homeInfo:GKHomeInfo){
        let vc : GKHomeMoreController = GKHomeMoreController(info:homeInfo);
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true);
    }
    class func jumpToSortBook(sortId:String, name:String){
//        let vc:SortBookListController = SortBookListController(sortId: sortId, name: name)
//        vc.hidesBottomBarWhenPushed = true;
        let vc: SortBookController = SortBookController(sortId: sortId, name: name)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true);
    }
    class func jumpToBookCase(){
        let root : UIViewController =  UIViewController.rootTopPresentedController();
        let vc:GKBookCaseController = GKBookCaseController()
        vc.hidesBottomBarWhenPushed = true;
        
        root.navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToNovel(bookModel :GKBookModel){
        let vc:GKNovelContentController = GKNovelContentController(bookModel: bookModel)
        vc.hidesBottomBarWhenPushed = true;
        let nvc : BaseNavigationController = BaseNavigationController.init(rootViewController: vc);
        nvc.modalPresentationStyle = .fullScreen;
//        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
        UIViewController.rootTopPresentedController().present(nvc, animated: false, completion: nil);
    }
    class func jumpToBrowse(){
        let vc:GKBrowseController = GKBrowseController();
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true);
    }
    class func jumpToSearch(){
        let vc:GKSearchHistoryController  = GKSearchHistoryController();
        vc.hidesBottomBarWhenPushed = true;
//        let nvc : BaseNavigationController = BaseNavigationController(rootViewController: vc)
//        nvc.modalPresentationStyle = .fullScreen;
//        UIViewController.rootTopPresentedController().present(nvc, animated: false, completion: nil)
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false);
    }
    class func jumpToSearchResult(keyWord :String){
        let vc: GKSearchResultController = GKSearchResultController(keyWord: keyWord)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true);
    }
    @objc class func window() -> UIWindow{
        let app:UIApplication = UIApplication.shared;
        if (app.delegate?.responds(to: #selector(window)))! {
            return ((app.delegate?.window)!)!;
        }
        return app.keyWindow!;
    }
    class func jumpToLaunchController(){
        let vc :UIViewController = UIViewController.rootTopPresentedController();
        let start : GKLaunchController = GKLaunchController();
        let nvc = BaseNavigationController.init(rootViewController: start);
        nvc.modalPresentationStyle = .fullScreen;
        vc.present(nvc, animated: false, completion: nil);
        
    }
}
