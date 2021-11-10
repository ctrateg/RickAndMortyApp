import UIKit

protocol LocationTableViewOutput: AnyObject {
  init(view: LocationTableViewInput)
  func getLocationsRequest(tableView: UITableView)
  func numberOfRows() -> Int
  func cellView(cell: LocationTableViewCell, indexPath: IndexPath) -> UITableViewCell
  func rowClicked(card: LocationCardTVC, indexPath: IndexPath)
  func didScroll(scrollView: UIScrollView)
}

class LocationTableViewPresenter: LocationTableViewOutput {
  private weak var view: LocationTableViewInput?

  private var endOfScroll: Int?
  private var loadMoreStatus = false
  private var page = 0
  private var locationRequestResults: [LocationResultsDTO] = []

  private weak var requestLocationApi: RequestServiceProtocol?
  private weak var userCacheLoadDelegate: LocalCacheLoadProtocol?

  required init(view: LocationTableViewInput) {
    self.view = view
    requestLocationApi = RequestServiceAPI.shared
    userCacheLoadDelegate = LocalDataManager.shared
  }
  func getLocationsRequest(tableView: UITableView) {
    self.requestLocationApi?.locationRequestAPI(page: String(self.page)) { responce in
      self.locationRequestResults = responce.results
      self.endOfScroll = responce.info.pages
      DispatchQueue.main.async {
        tableView.reloadData()
      }
    }
  }

  func numberOfRows() -> Int {
    return locationRequestResults.count
  }

  func cellView(cell: LocationTableViewCell, indexPath: IndexPath) -> UITableViewCell {
    let data = self.locationRequestResults[indexPath.row]
    if LocalDataManager.favoriteLocation.contains(where: { $0.id == (data.id) }) {
      cell.favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      cell.favoriteButton.tintColor = CustomColors.mainColor
      let deleteObject = LocalDataManager.favoriteLocation.first { $0.id == (data.id) } ?? LocationCache()
      cell.presenter?.cellDeleteObject(deleteObject: deleteObject)
      cell.presenter?.cellClicked(clicked: true)
    } else {
      cell.favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      cell.favoriteButton.tintColor = .darkGray
      cell.presenter?.cellClicked(clicked: false)
    }
    cell.presenter?.cellDataRequest(dataCellRequest: data)
    cell.locationName.text = data.name
    return cell
  }

  func rowClicked(card: LocationCardTVC, indexPath: IndexPath) {
    card.locationURL.append(self.locationRequestResults[indexPath.row].url)
    view?.goCard(episodeCard: card)
  }

  func didScroll(scrollView: UIScrollView) {
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
    self.view?.setActivityIndicator()
    loadMoreBegin {(_: Int) -> Void in
      self.loadMoreStatus = false
      self.view?.removeActivityIndicator()
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
}
