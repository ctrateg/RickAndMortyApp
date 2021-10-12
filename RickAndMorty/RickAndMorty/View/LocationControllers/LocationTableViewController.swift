import UIKit

class LocationTableViewController: UITableViewController {
  private lazy var userCachData = {
    return UserCacheData()
  }
  private lazy var informatorObj = {
    return Informator()
  }
  private var tagCharacter = "location"
  private var loadMoreStatus = false
  private var page = 1
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private var locationCache: [LocationCache] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    userCachData().loadItems { [weak self] responce in
      self?.locationCache = responce
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationCache.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "LocationCell",
      for: indexPath) as? LocationTableViewCell else {
        return UITableViewCell()
    }
    let data = locationCache[indexPath.row]
    cell.locationName.text = data.name ?? ""
    return cell
  }
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if deltaOffset <= 0 {
      loadMore()
    }
  }
  func loadMore() {
    if !loadMoreStatus {
    self.loadMoreStatus = true
    self.setLoadingScreen()
    loadMoreBegin(tag: tagCharacter) {(_: Int) -> Void in
      self.tableView.reloadData()
      self.loadMoreStatus = false
      self.removeLoadingScreen()
    }
    }
  }

  func loadMoreBegin(tag: String, loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .default).async {
      self.page += 1
      self.informatorObj().takeInCache(tag: tag, page: String(self.page))
      self.userCachData().loadItems { [weak self] responce in
        self?.locationCache = responce
      }
      DispatchQueue.main.async {
      loadMoreEnd(0)
      }
    }
  }

  // экран индикатора при подгрузках
  func setLoadingScreen() {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height ?? 0)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    indicator.style = .medium
    indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    indicator.startAnimating()
    loadView.addSubview(indicator)
    tableView.addSubview(loadView)
    tableView.isScrollEnabled = false
    sleep(2)
    }

  func removeLoadingScreen() {
    indicator.stopAnimating()
    indicator.isHidden = true
    tableView.isScrollEnabled = true
  }
}
