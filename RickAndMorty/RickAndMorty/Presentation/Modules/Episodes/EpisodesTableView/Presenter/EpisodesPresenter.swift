import UIKit

protocol EpisodesTableViewOutput: AnyObject {
  init(view: EpisodesTableViewInput)
  func getEpisodesRequest(tableView: UITableView)
  func cellView(cell: EpisodesTableViewCell, indexPath: IndexPath) -> UITableViewCell
  func numberOfRows() -> Int
  func rowClicked(card: EpisodesCardTVC, indexPath: IndexPath)
  func didScroll(scrollView: UIScrollView)
}

class EpisodesTableViewPresenter: EpisodesTableViewOutput {
  private weak var view: EpisodesTableViewInput?

  private var endOfScroll: Int?
  private var loadMoreStatus = false
  private var page = 0
  private var episodesRequestResult: [EpisodesResultsDTO] = []
  private weak var requestEpisdesApi: RequestServiceProtocol?

  required init(view: EpisodesTableViewInput) {
    self.view = view
    requestEpisdesApi = RequestServiceAPI.shared
  }
  func getEpisodesRequest(tableView: UITableView) {
    self.requestEpisdesApi?.episodesRequestAPI(page: String(self.page)) { [weak self] responce in
      self?.episodesRequestResult = responce.results
      self?.endOfScroll = responce.info.pages
      DispatchQueue.main.async {
        tableView.reloadData()
      }
    }
  }
  func numberOfRows() -> Int {
    return episodesRequestResult.count
  }
  func cellView(cell: EpisodesTableViewCell, indexPath: IndexPath) -> UITableViewCell {
    let data = episodesRequestResult[indexPath.row]
    let episodes = data.episode
    if LocalDataManager.favoriteEpisodes.contains(where: { $0.id == (data.id) }) {
      cell.favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      cell.favoriteButton.tintColor = CustomColors.mainColor
      let deleteObject = LocalDataManager.favoriteEpisodes.first { $0.id == (data.id) } ?? EpisodesCache()
      cell.presenter?.cellDeleteObject(deleteObject: deleteObject)
      cell.presenter?.cellClicked(clicked: true)
    } else {
      cell.favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      cell.favoriteButton.tintColor = .darkGray
      cell.presenter?.cellClicked(clicked: false)
    }
    cell.presenter?.cellDataRequest(dataCellRequest: data)
    cell.episodesTitle.text = data.name
    cell.episodesNumber.text = "Season" + " ".episodesSubTitleFix(line: episodes, tag: "S")
    + ", " + "Episode" + " ".episodesSubTitleFix(line: episodes, tag: "E")
    return cell
  }
  func rowClicked(card: EpisodesCardTVC, indexPath: IndexPath) {
    card.episodesURL.append(self.episodesRequestResult[indexPath.row].url)
    view?.goCard(episodeCard: card)
  }
  func didScroll(scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if (deltaOffset <= 0) && (page <= (endOfScroll ?? 0)) {
      loadMore()
    }
  }

  func loadMore() {
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
      self.requestEpisdesApi?.episodesRequestAPI(page: String(self.page)) { responce in
        self.episodesRequestResult.append(contentsOf: responce.results)
      }
      DispatchQueue.main.async {
        loadMoreEnd(0)
      }
    }
  }
}
