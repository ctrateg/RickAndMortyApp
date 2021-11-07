import UIKit
import Kingfisher

class CharactersTableView: UITableViewController {
  private weak var userCacheLoadDelegate: LocalCacheLoadProtocol?
  private weak var searchDelegate: RequestSerivceSearchProtocol?
  private weak var requestCharApi: RequestServiceProtocol?

  private var endOfScrolls: Int?
  private var characterRequestResult: [CharacterResultsDTO] = []
  private var searchRequestResult: [CharacterResultsDTO]?
  private var loadMoreStatus = false
  private var searching = false
  private var page = 0

  private let cardStoryboard = UIStoryboard(name: "CharactersUI", bundle: nil)
  private let loadView = UIView()
  private let searchBarController = UISearchController()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presentVC = cardStoryboard.instantiateViewController(
      withIdentifier: "CharacterCardTVC") as? CharacterCardTVC
    else { return }
    if searching == true {
      presentVC.characterURL.append(self.searchRequestResult?[indexPath.row].url ?? "")
    } else {
      presentVC.characterURL.append(self.characterRequestResult[indexPath.row].url)
    }
    show(presentVC, sender: nil)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.page = 0
    self.searchBarController.searchBar.delegate = self
    self.userCacheLoadDelegate = LocalDataManager.shared
    self.requestCharApi = RequestServiceAPI.shared
    self.searchDelegate = RequestServiceAPI.shared
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
      return searchRequestResult?.count ?? 0
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
      let data = searchRequestResult?[indexPath.row]
      return cellConfiguration(cell: cell, data: data, index: indexPath.row)
    }
    let data = characterRequestResult[indexPath.row]
    return cellConfiguration(cell: cell, data: data, index: indexPath.row)
  }

  private func cellConfiguration(cell: CharacterTableViewCell, data: CharacterResultsDTO?, index: Int) -> UITableViewCell {
    let imageURL = URL(string: data?.image ?? "")
    if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data?.id ?? 0) }) {
      cell.favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      cell.favoriteButton.tintColor = UIColor(named: "MainColor")
      cell.deleteObject = LocalDataManager.favoriteCharacters.first { $0.id == (data?.id ?? 0) }
      cell.clicked = true
    } else {
      cell.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
      cell.favoriteButton.tintColor = .darkGray
      cell.clicked = false
    }
    cell.characterName.text = data?.name
    cell.characterIcon.kf.setImage(with: imageURL)
    switch data?.status {
    case "Alive":
      cell.characterStatus.textColor = .green
      cell.characterStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoriteButton.isHidden = false
    case "Dead":
      cell.characterStatus.textColor = .red
      cell.characterStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoriteButton.isHidden = true
    default:
      cell.characterStatus.text = ""
    }
    cell.dataCellRequest = data
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
}

extension CharactersTableView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    searchBar.text = ""
    searchRequestResult = nil
    tableView.reloadData()
  }
}
