import UIKit

class LocationTableViewController: UITableViewController {
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()
  private let cardStoryboard = UIStoryboard(name: "LocationUI", bundle: nil)

  private var endOfScroll: Int?
  private var loadMoreStatus = false
  private var page = 0
  private var locationRequestResults: [LocationResultDTO] = []

  private weak var requestLocationApi: RequestServiceProtocol?
  private weak var userCacheLoadDelegate: UserCacheLoadProtocol?

  @IBAction func segueButton(_ sender: UIButton) {
    let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = tableView.indexPathForRow(at: buttonPosition)
    guard let presentVC = cardStoryboard.instantiateViewController(
      withIdentifier: "LocationCardTVC") as? LocationCardTVC
    else { return }
    presentVC.locationURL.append(self.locationRequestResults[indexPath?.row ?? 0].url)
    show(presentVC, sender: sender)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    page = 0
    requestLocationApi = RequestServiceAPI.shared
    userCacheLoadDelegate = LocalDataManager.shared
    configurationNavgiationC()
    request()
  }

  private func request(page: String = "1") {
    setLoadingScreen()
    self.requestLocationApi?.locationRequestAPI(page: String(self.page)) { responce in
      self.locationRequestResults = responce.results
      self.endOfScroll = responce.info.pages
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    self.page = 1
    removeLoadingScreen()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.locationRequestResults.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "LocationCell",
      for: indexPath) as? LocationTableViewCell else {
        return UITableViewCell()
    }
    let data = self.locationRequestResults[indexPath.row]
    if LocalDataManager.favoriteLocation.contains(where: { $0.id == (data.id) }) {
      cell.favoritIconOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      cell.favoritIconOutlet.tintColor = UIColor(named: "MainColor")
      cell.deletObject = LocalDataManager.favoriteLocation.first { $0.id == (data.id) }
      cell.clicked = true
    } else {
      cell.favoritIconOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      cell.favoritIconOutlet.tintColor = .darkGray
      cell.clicked = false
    }
    cell.indexPathRow = indexPath.row
    cell.dataCellRequest = data
    cell.locationName.text = data.name
    return cell
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if deltaOffset <= 0 && (page != endOfScroll) {
      loadMore()
    }
  }

  private func loadMore() {
    if !loadMoreStatus {
    self.loadMoreStatus = true
    self.setLoadingScreen()
    loadMoreBegin {(_: Int) -> Void in
      self.loadMoreStatus = false
      self.removeLoadingScreen()
    }
    }
  }

  func loadMoreBegin(loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .default).async {
      self.page += 1
      self.requestLocationApi?.locationRequestAPI(page: String(self.page)) {  responce in
        self.locationRequestResults.append(contentsOf: responce.results)
      }
      DispatchQueue.main.async {
      loadMoreEnd(0)
      }
    }
  }

  // экран индикатора при подгрузках
  private func setLoadingScreen() {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height ?? 0)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    indicator.style = .large
    indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    indicator.startAnimating()
    loadView.addSubview(indicator)
    tableView.addSubview(loadView)
    tableView.isScrollEnabled = false
    }

  private func removeLoadingScreen() {
    indicator.stopAnimating()
    indicator.isHidden = true
    tableView.isScrollEnabled = true
  }

  private func configurationNavgiationC() {
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.navigationItem.title = "Location"
    navigationItem.backButtonTitle = "Back"
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
