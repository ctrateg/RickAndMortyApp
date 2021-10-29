import UIKit

class CharactersTableView: UITableViewController, UISearchBarDelegate {
  private weak var userCacheLoadDelegate: UserCacheLoadDelegate?
  private weak var informatorDelegate: InformatorDelegate?
  private weak var searchDelegate: RequestSerivceSearchDelegate?
  private weak var getImageDelegate: GetImageDelegate?

  private var characterSearchArray: [CharacterCache] = []
  private var searchRequestResult: CharacterDTO?
  private var loadMoreStatus = false
  private var searching = false
  private var page = 1
  private var searchTimer: Timer?

  private let cardStoryboard = UIStoryboard(name: "CharactersUI", bundle: nil)
  private let loadView = UIView()
  private let searchBarController = UISearchController()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.searchBarController.searchBar.delegate = self
    let requestObj = RequestServiceAPI.shared
    userCacheLoadDelegate = UserCacheData.shared
    getImageDelegate = UserCacheData.shared
    searchDelegate = requestObj
    informatorDelegate = Informator.shared
    searchBarConfiguration()
    configurationNavgiationC()
  }

  private func searchBarConfiguration() {
    navigationItem.searchController = searchBarController
    searchBarController.searchBar.searchTextField.backgroundColor = .white
    searchBarController.searchBar.searchTextField.textColor = .black
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searching == true {
      return searchRequestResult?.results.count ?? characterSearchArray.count
    }
    return UserCacheData.characterCache.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath) as? CharacterTableViewCell else {
        return UITableViewCell()
    }
    cell.indexPathRow = indexPath.row
    if (characterSearchArray.count) > indexPath.row && searching == true {
      let data = characterSearchArray[indexPath.row]
      return cellInputData(cell: cell, data: data)
    } else if searching == true {
      return cellInputDataSearch(
        cell: cell,
        data: (searchRequestResult?.results[indexPath.row]))
    }
    let data = UserCacheData.characterCache[indexPath.row]
    return cellInputData(cell: cell, data: data)
  }

  private func cellInputDataSearch(cell: CharacterTableViewCell, data: CharacterResultDTO?) -> UITableViewCell {
    cell.characterName.text = data?.name
    guard let dataImage = getImageDelegate?.getImage(urlInput: data?.image ?? "") else { return UITableViewCell() }
    cell.characterIcon.image = UIImage(data: dataImage)
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
    return cell
  }

  private func cellInputData(cell: CharacterTableViewCell, data: CharacterCache) -> UITableViewCell {
    cell.characterName.text = data.name
    guard let dataImage = data.image else { return UITableViewCell() }
    cell.characterIcon.image = UIImage(data: dataImage)
    switch data.status {
    case "Alive":
      cell.charactetrStatus.textColor = .green
      cell.charactetrStatus.text = "\u{2022}" + (data.status ?? "")
      cell.favoritIconOutlet.isHidden = false
    case "Dead":
      cell.charactetrStatus.textColor = .red
      cell.charactetrStatus.text = "\u{2022}" + (data.status ?? "")
      cell.favoritIconOutlet.isHidden = true
    default:
      cell.charactetrStatus.text = ""
    }
    return cell
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if deltaOffset <= 20 && searching == false {
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

  private func loadMoreBegin(loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .background).async {
      self.page += 1
      self.informatorDelegate?.takeInCache(tag: .character, page: String(self.page))
      self.userCacheLoadDelegate?.loadItems { responce in
        UserCacheData.characterCache = responce
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
        self?.characterSearchArray = UserCacheData.characterCache.filter { item in
          item.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
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
    characterSearchArray = []
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
    presentVC.characterCache = UserCacheData.characterCache[indexPath?.row ?? 0]
    show(presentVC, sender: sender)
  }
}
