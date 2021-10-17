import UIKit

class CharactersTableView: UITableViewController, UISearchBarDelegate {
  private let searchBarController = UISearchController()
  private weak var userCacheLoadDelegate: UserCacheLoadDelegate?
  private weak var informatorDelegate: InformatorDelegate?
  private weak var searchDelegate: RequestSerivceSearchDelegate?
  private var characterCache: [CharacterCache] = []
  private var characterSearchArray: [CharacterCache] = []
  private var searchRequestResult: CharacterDTO?
  private var tagCharacter = "character"
  private var loadMoreStatus = false
  private var searching = false
  private var page = 1
  private var searchTimer: Timer?
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchBarController.searchBar.delegate = self
    userCacheLoadDelegate = UserCacheData.shared
    searchDelegate = RequestServiceAPI.shared
    informatorDelegate = Informator.shared
    searchBarConfiguration()
    tableView.reloadData()
    configurationNavgiationC()
    navigationItem.searchController = searchBarController
  }
  func searchBarConfiguration() {
    searchBarController.searchBar.searchTextField.backgroundColor = .white
    searchBarController.searchBar.searchTextField.textColor = .black
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searching == true {
      return (characterSearchArray.count + (searchRequestResult?.results.count ?? 0)) - 2
    }
    return characterCache.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath) as? CharacterTableViewCell else {
        return UITableViewCell()
    }
    if searching == true {
      if (characterSearchArray.count - 1) > indexPath.row {
        let data = characterSearchArray[indexPath.row]
        return cellInputData(cell: cell, data: data)
      } else {
        return cellInputDataSearch(
          cell: cell,
          data: (searchRequestResult?.results[indexPath.row]))
      }
    } else {
      let data = characterCache[indexPath.row]
      return cellInputData(cell: cell, data: data)
    }
  }
  private func cellInputDataSearch(cell: CharacterTableViewCell, data: CharacterResultDTO?) -> UITableViewCell {
    cell.characterName.text = data?.name
    guard let dataImage = getImage(urlInput: data?.image ?? "") else { return UITableViewCell() }
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
  private func getImage(urlInput: String) -> Data? {
    guard let url = URL(string: urlInput) else { return nil }
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch _ as NSError {
      print("Save image error")
    }
    return nil
  }
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if deltaOffset <= 20 && searching == false {
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
      self.informatorDelegate?.takeInCache(tag: tag, page: String(self.page))
      self.userCacheLoadDelegate?.loadItems { [weak self] responce in
        self?.characterCache = responce
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
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchTimer?.invalidate()
    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        self?.characterSearchArray = self?.characterCache
          .filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() } ?? []
        self?.searchDelegate?.characterSearch(tag: searchText) { searchResponce in
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
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
