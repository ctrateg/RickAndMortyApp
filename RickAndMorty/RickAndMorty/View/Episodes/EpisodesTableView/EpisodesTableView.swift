import UIKit

class EpisodesTableViewController: UITableViewController {
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()
  private let cardStoryboard = UIStoryboard(name: "EpisodesUI", bundle: nil)

  private var endOfScroll: Int?
  private var loadMoreStatus = false
  private var page = 0
  private var episodesRequestResult: [EpisodesResultDTO] = []
  private weak var requestEpisdesApi: RequestServiceDelegate?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    page = 0
    requestEpisdesApi = RequestServiceAPI.shared
    configurationNavgiationC()
    request()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  private func request(page: String = "1") {
    setLoadingScreen()

    self.requestEpisdesApi?.episodesRequestAPI(page: String(self.page)) { [weak self] responce in
      self?.episodesRequestResult = responce.results
      self?.endOfScroll = responce.info.pages
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    self.page = 0
    removeLoadingScreen()
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodesRequestResult.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "EpisodesCell",
      for: indexPath) as? EpisodesTableViewCell else {
        return UITableViewCell()
    }
    let data = episodesRequestResult[indexPath.row]
    let episodes = data.episode
    cell.episodesTitle.text = data.name
    cell.episodesNumber.text = "Season " + episodesSubTitleFix(line: episodes, tag: "S")
    + ", " + "Episode " + episodesSubTitleFix(line: episodes, tag: "E")
    return cell
  }
  private func episodesSubTitleFix(line: String, tag: String) -> String {
    guard let eRange = line.range(of: "E") else { return "" }
    guard let sEange = line.range(of: "S")?.upperBound else { return "" }
    switch tag {
    case "S": return String(line[sEange..<eRange.lowerBound])
    case "E": return String(line[eRange.upperBound...])
    default: return ""
    }
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if (deltaOffset <= 0) && (page != endOfScroll) {
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
      self.requestEpisdesApi?.episodesRequestAPI(page: String(self.page)) { responce in
        self.episodesRequestResult.append(contentsOf: responce.results)
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
    presentVC.episodesURL.append(self.episodesRequestResult[indexPath?.row ?? 0].url)
    self.page = 0
    show(presentVC, sender: sender)
  }
}
