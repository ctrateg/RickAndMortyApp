import UIKit

class EpisodesTableViewController: UITableViewController {
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()
  private let cardStoryboard = UIStoryboard(name: "EpisodesUI", bundle: nil)

  private var loadMoreStatus = false
  private var page = 1

  private weak var informatorDelegate: InformatorDelegate?
  private weak var userCacheLoadDelegate: UserCacheLoadDelegate?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    userCacheLoadDelegate = UserCacheData.shared
    informatorDelegate = Informator.shared
    configurationNavgiationC()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserCacheData.episodesCache.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "EpisodesCell",
      for: indexPath) as? EpisodesTableViewCell else {
        return UITableViewCell()
    }
    let data = UserCacheData.episodesCache[indexPath.row]
    let strArray = { () -> [Character] in
      var array: [Character] = []
      guard let episodes = data.episodes else { return [] }
      for str in episodes {
        array.append(str)
      }
      return array
    }
    cell.episodesTitle.text = data.name
    cell.episodesNumber.text = "Season " + strArray()[2..<3] + ", " + "Episode " + strArray()[4...5]
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
    loadMoreBegin {(_: Int) -> Void in
      self.loadMoreStatus = false
      self.removeLoadingScreen()
    }
    }
  }

  func loadMoreBegin(loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .default).async {
      self.page += 1
      self.informatorDelegate?.takeInCache(tag: .episodes, page: String(self.page))
      self.userCacheLoadDelegate?.loadItems { responce in
        UserCacheData.episodesCache = responce
      }
      DispatchQueue.main.async {
      loadMoreEnd(0)
      }
    }
  }

  // экран индикатора при подгрузках
  func setLoadingScreen() {
    let width: CGFloat = 60
    let height: CGFloat = 60
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

  func removeLoadingScreen() {
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
    self.navigationItem.title = "Episodes"
    navigationItem.backButtonTitle = "Back"
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
  @IBAction func segueButtonn(_ sender: UIButton) {
    let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = tableView.indexPathForRow(at: buttonPosition)
    guard let presentVC = cardStoryboard.instantiateViewController(
      withIdentifier: "EpisodesCardTVC") as? EpisodesCardTVC
    else { return }
    presentVC.episodesCache = UserCacheData.episodesCache[indexPath?.row ?? 0]
    show(presentVC, sender: sender)
  }
}
