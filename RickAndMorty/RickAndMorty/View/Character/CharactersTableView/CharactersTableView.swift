import UIKit
import Kingfisher

class CharactersTableView: UITableViewController, UISearchBarDelegate {
  private weak var userCacheLoadDelegate: UserCacheLoadDelegate?
  private weak var searchDelegate: RequestSerivceSearchDelegate?
  private weak var requestCharApi: RequestServiceDelegate?

  private var endOfScrolls: Int?
  private var characterRequestResult: [CharacterResultDTO] = []
  private var searchRequestResult: CharacterDTO?
  private var loadMoreStatus = false
  private var searching = false
  private var page = 0
  private var searchTimer: Timer?

  private let cardStoryboard = UIStoryboard(name: "CharactersUI", bundle: nil)
  private let loadView = UIView()
  private let searchBarController = UISearchController()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    page = 0
    self.searchBarController.searchBar.delegate = self
    let requestObj = RequestServiceAPI.shared
    userCacheLoadDelegate = UserCacheData.shared
    requestCharApi = requestObj
    searchDelegate = requestObj
    request()
    searchBarConfiguration()
    configurationNavgiationC()
  }
  private func request(page: String = "1") {
    setLoadingScreen()

    self.requestCharApi?.characterRequestAPI(page: String(self.page)) { responce in
      self.characterRequestResult = responce.results
      self.endOfScrolls = responce.info.pages
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    self.page = 1
    removeLoadingScreen()
  }
  private func searchBarConfiguration() {
    navigationItem.searchController = searchBarController
    searchBarController.searchBar.searchTextField.backgroundColor = .white
    searchBarController.searchBar.searchTextField.textColor = .black
    searchBarController.searchBar.searchTextField.tintColor = .systemGray
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searching == true {
      return searchRequestResult?.results.count ?? 0
    }
    return characterRequestResult.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath) as? CharacterTableViewCell else {
        return UITableViewCell()
    }
    if searching == true {
      let data = searchRequestResult?.results[indexPath.row]
      return cellConfiguration(cell: cell, data: data, index: indexPath.row)
    }
    let data = characterRequestResult[indexPath.row]
    return cellConfiguration(cell: cell, data: data, index: indexPath.row)
  }

  private func cellConfiguration(cell: CharacterTableViewCell, data: CharacterResultDTO?, index: Int) -> UITableViewCell {
    let imageURL = URL(string: data?.image ?? "")
    cell.characterName.text = data?.name
    cell.characterIcon.kf.setImage(with: imageURL)
    switch data?.status {
    case "Alive":
      cell.charactetrStatus.textColor = .green
      cell.charactetrStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoritIconOutlet.isHidden = false
    case "Dead":
      cell.charactetrStatus.textColor = .red
      cell.charactetrStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoritIconOutlet.isHidden = true
    default:
      cell.charactetrStatus.text = ""
    }
    cell.dataCellRequest = data
    cell.indexPathRow = index
    return cell
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if (deltaOffset <= 0) && (searching == false) && (page != endOfScrolls) {
      loadMore()
    }
  }
  private func loadMore() {
    if !loadMoreStatus {
    self.loadMoreStatus = true
    self.setLoadingScreen()
    loadMoreBegin {(_: Int) -> Void in
      self.tableView.reloadData()
      self.loadMoreStatus = false
      self.removeLoadingScreen()
    }
    }
  }

  private func loadMoreBegin(loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .background).async {
      self.page += 1
      self.requestCharApi?.characterRequestAPI(page: String(self.page)) { responce in
        self.characterRequestResult.append(contentsOf: responce.results)
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
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchTimer?.invalidate()
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        self?.searchDelegate?.characterSearch(tag: searchText) { [weak self] searchResponce in
          self?.searchRequestResult = searchResponce
        }
        DispatchQueue.main.async {
          self?.searching = true
          self?.tableView.reloadData()
        }
      }
    }
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    searchBar.text = ""
    searchRequestResult = nil
    tableView.reloadData()
  }

  private func configurationNavgiationC() {
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.navigationItem.title = "Character"
    navigationItem.backButtonTitle = "Back"
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
  @IBAction func segueButton(_ sender: UIButton) {
    let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = tableView.indexPathForRow(at: buttonPosition)
    guard let presentVC = cardStoryboard.instantiateViewController(
      withIdentifier: "CharacterTableViewCard") as? CharacterTableViewCard
    else { return }
    if searching == true {
      presentVC.characterURL.append(self.searchRequestResult?.results[indexPath?.row ?? 0].url ?? "")
    } else {
      presentVC.characterURL.append(self.characterRequestResult[indexPath?.row ?? 0].url)
    }
    show(presentVC, sender: sender)
  }
}
