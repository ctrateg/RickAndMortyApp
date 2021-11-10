import UIKit
import Kingfisher
import CoreData

protocol CharacterCardOutput: AnyObject {
  init(view: CharacterCardInput)
  func viewForHeaderInSection(section: Int, tableViewController: CharacterCardTVC, collectionView: UICollectionView) -> UIView?
  func didSelectRowAt(indexPath: IndexPath)
  func didSelectItemAtCollection(indexPath: IndexPath)

  func heightForHeaderInSection(section: Int) -> CGFloat
  func heightForRowAt(indexPath: IndexPath) -> CGFloat
  func numberOfRowsInSection(section: Int) -> Int
  func numberOfItemsInSectionCollection() -> Int
  func sharedView()
  func cellConfiguration(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  func cellForItemAtCollection(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
  func characterRequest(tableView: UITableView, urlArray: [String])
}

class CharacterCardPresenter: CharacterCardOutput {
  private weak var view: CharacterCardInput?
  private weak var serviceRequest: SingleRequestProtocol?
  private weak var serviceSearchRequest: RequestSerivceSearchProtocol?
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?
  private var headerConfigProtocol: CharacterHeaderProtocol?

  private var deleteObject: CharacterCache?
  private var clickedTopButton = false
  private var cardArray: [String]?
  private var titles = ["Status", "Type", "Gender", "Date"]
  private var characterRequestResult: [CharacterResultsDTO]?
  private var episodeRequestResult: [EpisodesResultsDTO]?
  private var locationRequestResult: [LocationResultsDTO]?
  private var characterSearchResult: [CharacterResultsDTO]?

  required init(view: CharacterCardInput) {
    self.view = view
    saveInCacheProtocol = LocalDataManager.shared
    deleteFromCache = LocalDataManager.shared
    serviceSearchRequest = RequestServiceAPI.shared
    serviceRequest = RequestServiceAPI.shared
  }

  func characterRequest(tableView: UITableView, urlArray: [String]) {
    DispatchQueue.global(qos: .background).async {
      self.serviceRequest?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
        self?.characterRequestResult = responce
        self?.cardArray = [
          responce[0].status ?? "",
          responce[0].type ?? "",
          responce[0].gender ?? "",
          String(self?.dateFormatterConfiguration(data: responce[0].created) ?? "")
        ]
        self?.episodesRequest(urlArray: responce[0].episode )
        self?.locationRequest(urlArray: responce[0].location?.url ?? "")
        self?.similarCharacters(tag: responce[0].name)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        tableView.reloadData()
      }
    }
  }

  func heightForRowAt(indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }

  func viewForHeaderInSection(section: Int, tableViewController: CharacterCardTVC, collectionView: UICollectionView) -> UIView? {
    guard let characterResult = characterRequestResult?[0] else { return UIView() }
    headerConfigProtocol = CharacterHeaderConfigurations.shared
    CharacterHeaderConfigurations.shared.saveObject = characterResult
    switch section {
    case 1:
      return headerConfigProtocol?.middleHeaderConfiguration(text: "LOCATION", tableView: tableViewController.tableView)
    case 2:
      return headerConfigProtocol?.middleHeaderConfiguration(text: "EPISODES", tableView: tableViewController.tableView)
    case 3:
      return headerConfigProtocol?.bottomHeaderConfiguration(
        cardTVC: tableViewController,
        collectionView: collectionView,
        tableView: tableViewController.tableView)
    default:
      return headerConfigProtocol?.topHeaderConfiguration(
        dataInput: characterResult,
        tableView: tableViewController.tableView)
    }
  }

  func didSelectRowAt(indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let presentVC = LocationCardTVC.createFromStoryboard as? LocationCardTVC else { return }
      presentVC.locationURL.append(self.characterRequestResult?[indexPath.row].location?.url ?? "")
      view?.showController(controller: presentVC)
    case 2:
      guard let presentVC = EpisodesCardTVC.createFromStoryboard as? EpisodesCardTVC else { return }
      presentVC.episodesURL.append(self.episodeRequestResult?[indexPath.row].url ?? "")
      view?.showController(controller: presentVC)
    default: return
    }
  }

  func heightForHeaderInSection(section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    case 3:
      return 195
    default:
      return 38
    }
  }

  func numberOfRowsInSection(section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    case 1:
      return 1
    case 2:
      return characterRequestResult?[0].episode.count ?? 0
    default:
      return 0
    }
  }

  func sharedView() {
    let returnValue = [characterRequestResult?[0].name, characterRequestResult?[0].image]
    let activityView = UIActivityViewController(activityItems: returnValue as [Any], applicationActivities: nil)
    view?.presentActivityView(activityView)
  }

  private func dateFormatterConfiguration(data: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: data) else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }

  private func episodesRequest(urlArray: [String]) {
    self.serviceRequest?.requestForEpisodes(urlArray: urlArray) { [weak self] responce in
      self?.episodeRequestResult = responce
    }
  }

  private func locationRequest(urlArray: String) {
    self.serviceRequest?.requestForLocation(urlArray: [urlArray]) { [weak self] responce in
      self?.locationRequestResult = responce
    }
  }

  private func similarCharacters(tag: String) {
    var searchItem = tag
    if let spaceRange = tag.range(of: " ") {
      searchItem.removeSubrange(spaceRange.lowerBound..<searchItem.endIndex)
    }
    self.serviceSearchRequest?.characterSearch(tag: searchItem) { [weak self] responce in
      self?.characterSearchResult = responce.filter { $0.id != self?.characterRequestResult?[0].id }
    }
  }

  func cellConfiguration(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let indexPathRow = indexPath.row
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "CharacterInfoCell",
        for: indexPath) as? CharacterInfoCell else { return UITableViewCell() }
      cell.detail.text = cardArray?[indexPathRow]
      cell.title.text = titles[indexPathRow]
      cell.title.textColor = .gray
      if cell.detail.text?.isEmpty == true {
        cell.detail?.text = "unknown"
      }
      return cell
    case 1:
      guard let cellLocation = tableView.dequeueReusableCell(
        withIdentifier: "CharacterLocationCell",
        for: indexPath) as? CharacterLocationCell else { return UITableViewCell() }
      let data = locationRequestResult?[indexPathRow]
      if LocalDataManager.favoriteLocation.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellLocation.favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
        cellLocation.favoriteButton.tintColor = UIColor(named: "MainColor")
        cellLocation.deleteObject = LocalDataManager.favoriteLocation.first { $0.id == (data?.id ?? 0) }
        cellLocation.clicked = true
      } else {
        cellLocation.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
        cellLocation.favoriteButton.tintColor = .darkGray
        cellLocation.clicked = false
      }
      cellLocation.dataCellRequest = locationRequestResult?[indexPathRow]
      cellLocation.name.text = data?.name
      return cellLocation
    case 2:
      guard let cellEpisode = tableView.dequeueReusableCell(
        withIdentifier: "CharacterEpisodeCell",
        for: indexPath) as? CharacterEpisodesCell else { return UITableViewCell() }
      let nameEpisodes = episodeRequestResult?[indexPathRow].name
      let descition = episodeRequestResult?[indexPathRow].episode
      let data = episodeRequestResult?[indexPathRow]
      if LocalDataManager.favoriteEpisodes.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellEpisode.favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
        cellEpisode.favoriteButton.tintColor = UIColor(named: "MainColor")
        cellEpisode.deleteObject = LocalDataManager.favoriteEpisodes.first { $0.id == (data?.id ?? 0) }
        cellEpisode.clicked = true
      } else {
        cellEpisode.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
        cellEpisode.favoriteButton.tintColor = .darkGray
        cellEpisode.clicked = false
      }
      cellEpisode.name.text = nameEpisodes
      cellEpisode.desciption.text = "Season " + "".episodesSubTitleFix(line: descition ?? "", tag: "S") + ", " +
      "Episode " + "".episodesSubTitleFix(line: descition ?? "", tag: "E")
      cellEpisode.dataCellRequest = episodeRequestResult?[indexPathRow]
      return cellEpisode
    default:
      return UITableViewCell()
    }
  }

  // MARK: - Collection view configurations
  func numberOfItemsInSectionCollection() -> Int {
    return characterSearchResult?.count ?? 0
  }

  func cellForItemAtCollection(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "collectionCell",
      for: indexPath) as? SimilarCollectionViewCell else { return UICollectionViewCell() }
    let data = characterSearchResult?[indexPath.row]
    let imageURL = URL(string: data?.image ?? "")
    cell.imageCollectionCell.kf.setImage(with: imageURL)
    cell.nameCollectionCell.text = data?.name
    return cell
  }

  func didSelectItemAtCollection(indexPath: IndexPath) {
    guard let presentVC = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC else { return }
    presentVC.characterURL.append(self.characterSearchResult?[indexPath.row + 1].url ?? "")
    view?.showController(controller: presentVC)
  }
}
