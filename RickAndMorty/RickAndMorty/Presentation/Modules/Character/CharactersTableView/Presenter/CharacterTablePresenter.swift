import UIKit
import Kingfisher

protocol CharactersTableViewOutput: AnyObject {
  init(view: CharactersTableViewInput)
  func rowClicked(card: CharacterCardTVC, indexPath: IndexPath)
  func getCharactersReuqest(tableView: UITableView)
  func numberOfRows() -> Int
  func cellView(cell: CharacterTableViewCell, indexPath: IndexPath) -> UITableViewCell
  func didScroll(scrollView: UIScrollView)
  func searchBarTextDidChange(searchBar: UISearchBar, searchText: String, tableView: UITableView)
  func cancelSearching()
  func protocolConfiguration(searchBar: UISearchBar, controller: CharactersTableViewController)
}

class CharactersTableViewPresenter: CharactersTableViewOutput {
  private weak var view: CharactersTableViewInput?

  private weak var userCacheLoadDelegate: LocalCacheLoadProtocol?
  private weak var searchDelegate: RequestSerivceSearchProtocol?
  private weak var requestCharApi: RequestServiceProtocol?

  private var characterRequestResult: [CharacterResultsDTO] = []
  private var searchRequestResult: [CharacterResultsDTO]?
  private var endOfScrolls: Int?
  private var loadMoreStatus = false
  private var searching = false
  private var page = 0

  required init(view: CharactersTableViewInput) {
    self.view = view
    self.userCacheLoadDelegate = LocalDataManager.shared
    self.requestCharApi = RequestServiceAPI.shared
    self.searchDelegate = RequestServiceAPI.shared
  }

  func rowClicked(card: CharacterCardTVC, indexPath: IndexPath) {
    if searching == true {
      card.characterURL.append(self.searchRequestResult?[indexPath.row].url ?? "")
    } else {
      card.characterURL.append(self.characterRequestResult[indexPath.row].url)
    }
    view?.goCard(characterCard: card)
  }

  func getCharactersReuqest(tableView: UITableView) {
    self.requestCharApi?.characterRequestAPI(page: String(self.page)) { responce in
      self.characterRequestResult = responce.results
      self.endOfScrolls = responce.info.pages
      DispatchQueue.main.async {
        tableView.reloadData()
      }
    }
  }

  func numberOfRows() -> Int {
    if searching == true {
      return searchRequestResult?.count ?? 0
    }
    return characterRequestResult.count
  }
  func cellView(cell: CharacterTableViewCell, indexPath: IndexPath) -> UITableViewCell {
    if searching == true {
      guard let data = searchRequestResult?[indexPath.row] else { return UITableViewCell() }
      return cellConfiguration(cell: cell, data: data, index: indexPath.row)
    }
    let data = characterRequestResult[indexPath.row]
    return cellConfiguration(cell: cell, data: data, index: indexPath.row)
  }


  private func cellConfiguration(cell: CharacterTableViewCell, data: CharacterResultsDTO, index: Int) -> UITableViewCell {
    let imageURL = URL(string: data.image)
    if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data.id ) }) {
      cell.favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      cell.favoriteButton.tintColor = CustomColors.mainColor
      let deleteObject = LocalDataManager.favoriteCharacters.first { $0.id == (data.id ) }
      cell.presenter?.cellDeleteObject(deleteObject: deleteObject ?? CharacterCache())
      cell.presenter?.cellClicked(clicked: true)
    } else {
      cell.favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      cell.favoriteButton.tintColor = .darkGray
      cell.presenter?.cellClicked(clicked: false)
    }
    cell.characterName.text = data.name
    cell.characterIcon.kf.setImage(with: imageURL)
    cell.presenter?.statusCase(
      status: data.status ?? "",
      characterStatus:
        cell.characterStatus,
      favoriteButton: cell.favoriteButton)
    cell.presenter?.cellDataRequest(dataCellRequest: data )
    return cell
  }

  func didScroll(scrollView: UIScrollView) {
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
      self.view?.setActivityIndicator()
      loadMoreBegin {(_: Int) -> Void in
        self.loadMoreStatus = false
        self.view?.removeActivityIndicator()
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

  func searchBarTextDidChange(searchBar: UISearchBar, searchText: String, tableView: UITableView) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      self?.searchDelegate?.characterSearch(tag: searchText) { [weak self] searchResponce in
        self?.searchRequestResult = searchResponce
      }
      DispatchQueue.main.async {
        self?.searching = true
        tableView.reloadData()
      }
    }
  }

  func cancelSearching() {
    searching = false
    searchRequestResult = nil
  }

  func protocolConfiguration(searchBar: UISearchBar, controller: CharactersTableViewController) {
    searchBar.delegate = controller
  }
}
