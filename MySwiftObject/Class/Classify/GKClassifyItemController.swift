//
//  GKClassifyItemController.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/5.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON
import ATRefresh_Swift

class GKClassifyItemController: BaseConnectionController {
    var titleName : String = ""{
        didSet{
            self.refreshData(page: 1)
        }
    }
    private lazy var listData: [GKClassifyModel] = {
        return [];
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRefresh(scrollView: self.collectionView, options:ATRefreshOption(rawValue: ATRefreshOption.header.rawValue | ATRefreshOption.autoHeader.rawValue));
    }
    override func vtm_prepareForReuse() {
        if !self.reachable {
            self.listData.removeAll();
            self.collectionView.reloadData();
        }
    }
    override func refreshData(page: Int) {
        RoubSiteNovelClassifyNet.getSmallSort(pId: self.titleName, sucesss: { (object) in
            if page == RefreshPageStart{
                self.listData.removeAll();
            }
            if object["status"] == "1"{
                let list:[JSON] = object["data"].arrayValue;
                for sortInfo in list {
                    let bean:GKClassifyModel = GKClassifyModel.init();
                    bean.title = sortInfo["SORT_NAME"].stringValue;
                    bean.id = sortInfo["SORT_ID"].stringValue;
                    bean.bookCount = sortInfo["COUNT"].intValue;
                    bean.cover = sortInfo["IMAGE"].stringValue;
                    self.listData.append(bean);
                }
                self.collectionView.reloadData();
                self .endRefresh(more:false);
            }else{

            }
            
            if let list : [JSON] = object[self.titleName].array{
                for obj in list{
//                    let decoder = JSONDecoder()
                    do {
                        let user = try JSONDecoder().decode(GKClassifyModel.self, from: obj.rawData())
                        self.listData.append(user);
                        print(user)
                    } catch {
                      //  print("error: \(error)")
                    }
                }
                self.collectionView.reloadData();
                self .endRefresh(more:false);
            }
            
        }) { (error) in
            self.endRefreshFailure();
        };
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
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
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 60)/3.0;
        let height = width * 1.35 + 30;
        return CGSize.init(width: width, height: height);
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :GKClassifyCell = GKClassifyCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:GKClassifyModel = self.listData[indexPath.row];
        GKJump.jumpToClassifyTail(sortId: model.id!, name: model.title!)
    }
    
}
