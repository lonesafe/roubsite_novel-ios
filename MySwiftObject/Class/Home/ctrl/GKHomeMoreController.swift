import UIKit

class GKHomeMoreController: BaseTableViewController {

    convenience init(info : GKHomeInfo) {
        self.init();
        self.bookInfo = info;
    }
    private var bookInfo:GKHomeInfo!
    private lazy var listData : [GKBookModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: self.bookInfo.shortTitle!);
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        RoubSiteBlockNet.getBlockNovelInfo(blockId: self.bookInfo.homeId, sucesss: { (object) in
            if let info : GKHomeInfo = GKHomeInfo.deserialize(from: object["ranking"].rawString()){
                self.bookInfo = info;
            }
            self.endRefresh(more: false);
        }) { (error) in
            self.endRefreshFailure()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookInfo.books.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :SortBookListItem = SortBookListItem.cellForTableView(tableView: tableView, indexPath: indexPath)
        cell.model = self.bookInfo.books[indexPath.row];
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true);
        let model:GKBookModel = self.bookInfo.books[indexPath.row];
        GKJump.jumpToDetail(bookId: model.bookId ?? "");
    }

}
