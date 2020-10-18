import UIKit

class GKMineController: BaseTableViewController {
    private let bookCase   :String = "我的书架"
    private let bookBrowse :String = "浏览记录"
    private let about      :String = "关于我们"
    
    private lazy var listData: [GKMineModel] = {
        return [];
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmpty(scrollView: self.tableView)
        self.setupRefresh(scrollView: self.tableView, options:.defaults)
    }
    override func refreshData(page: Int) {
        let model1:GKMineModel = GKMineModel.vcWithModel(title:bookCase, icon: "icon_fav", subTitle:"")
        let model2:GKMineModel = GKMineModel.vcWithModel(title:bookBrowse, icon: "icon_historys", subTitle:"")
        let model3:GKMineModel = GKMineModel.vcWithModel(title:about, icon: "icon_option", subTitle:"")
        self.listData = [model3,model1,model2];
        self.tableView.reloadData()
        self.endRefreshFailure();
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GKMineTableViewCell = GKMineTableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath) 
        let model :GKMineModel = self.listData[indexPath.row];
        cell.titleLab.text = model.title ;
        cell.lineView.isHidden = indexPath.row + 1 == self.listData.count;
        cell.imageV.image = UIImage.init(named: model.icon);
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model :GKMineModel = self.listData[indexPath.row];
        if model.title == bookCase {
            GKJump.jumpToBookCase();
        }else if model.title == bookBrowse{
            GKJump.jumpToBrowse();
        }
    }
}
