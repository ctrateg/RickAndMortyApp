import UIKit
import Kingfisher
import CoreData

class CharacterCardTVC: UITableViewController {
  private weak var serviceRequest: SingleRequestProtocol?
  private weak var serviceSearchRequest: RequestSerivceSearchProtocol?
  private weak var deleteFromCache: UserCacheDeleteProtocol?
  private weak var saveInCacheProtocol: UserCacheSaveProtocol?

  private var deletObject: CharacterCache?
  var characterURL: [String] = []
  private var clickedTopButton = false
  private var cardArray: [String]?
  private var titles: [String]?
  private var headerView: UIView?
  private var infoLabel: UILabel?
  private var characterRequestResult: [CharacterResultDTO]?
  private var episodeRequestResult: [EpisodesResultDTO]?
  private var locationRequestResult: [LocationResultDTO]?
  private var characterSearchResult: CharacterDTO?
  private var collectionView: UICollectionView?
  private var flow: UICollectionViewFlowLayout?

  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.saveInCacheProtocol = LocalDataManager.shared
    self.deleteFromCache = LocalDataManager.shared
    self.serviceSearchRequest = RequestServiceAPI.shared
    self.serviceRequest = RequestServiceAPI.shared
    self.characterRequest(urlArray: characterURL)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.titles = ["Status", "Type", "Gender", "Date"]
  }

  private func characterRequest(urlArray: [String]) {
    setLoadingScreen()
    DispatchQueue.global(qos: .default).async {
      self.serviceRequest?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
        self?.characterRequestResult = responce
        self?.cardArray = [
          responce[0].status ?? "",
          responce[0].type ?? "",
          responce[0].gender ?? "",
          String(self?.dateFormatterConfiguration(data: responce[0].created) ?? "")
        ]
        self?.episodesRequest(urlArray: responce[0].episode ?? [])
        self?.locationRequest(urlArray: responce[0].location?.url ?? "")
        self?.similarCharacters(tag: responce[0].name)
        sleep(1)
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    }
    removeLoadingScreen()
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
    self?.characterSearchResult = responce
    }
  }

  private func dateFormatterConfiguration(data: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: data) else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    case 1:
      return 1
    case 2:
      return characterRequestResult?[0].episode?.count ?? 0
    default:
      return 0
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let indexPathRow = indexPath.row
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "CharacterInfoCell",
        for: indexPath) as? CharacterInfoCell else { return UITableViewCell() }
      cell.detail.text = cardArray?[indexPathRow]
      cell.title.text = titles?[indexPathRow]
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
        cellLocation.deletObject = LocalDataManager.favoriteLocation.first { $0.id == (data?.id ?? 0) }
        cellLocation.clicked = true
      } else {
        cellLocation.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
        cellLocation.favoriteButton.tintColor = .darkGray
        cellLocation.clicked = false
      }
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
        cellEpisode.deletObject = LocalDataManager.favoriteEpisodes.first { $0.id == (data?.id ?? 0) }
        cellEpisode.clicked = true
      } else {
        cellEpisode.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
        cellEpisode.favoriteButton.tintColor = .darkGray
        cellEpisode.clicked = false
      }
      cellEpisode.name.text = nameEpisodes
      cellEpisode.desciption.text = "Season " + episodesSubTitleFix(line: descition ?? "", tag: "S") + ", " +
      "Episode " + episodesSubTitleFix(line: descition ?? "", tag: "E")
      return cellEpisode
    default:
      return UITableViewCell()
    }
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

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    case 3:
      return 195
    default:
      return 38
    }
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 1:
      return middleHeaderConfiguration(text: "LOCATION")
    case 2:
      return middleHeaderConfiguration(text: "EPISODES")
    case 3:
      return bottomHeaderConfiguration()
    default:
      return topHeaderConfiguration()
    }
  }

  private func bottomHeaderConfiguration() -> UIView? {
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 195))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 38))
    infoLabel?.text = "SIMILAR CHARACTERS"
    infoLabel?.textColor = .gray
    infoLabel?.font = .systemFont(ofSize: 14)

    flow = UICollectionViewFlowLayout()
    flow?.scrollDirection = .horizontal
    flow?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    flow?.itemSize = CGSize(width: 100, height: 150)

    collectionView = UICollectionView(
      frame: CGRect(x: 0, y: 40, width: tableView.frame.width, height: 155),
      collectionViewLayout: flow ?? UICollectionViewFlowLayout())
    collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView?.backgroundColor = .systemGray6
    collectionView?.register(
      UINib(nibName: "SimilarCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "collectionCell")

    collectionView?.delegate = self
    collectionView?.dataSource = self

    headerView?.addSubview(collectionView ?? UICollectionView())
    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }

  private func topHeaderConfiguration() -> UIView? {
    let favoriteButton = UIButton(frame: CGRect(x: 122, y: 75, width: 160, height: 24))
    let imageCard = UIImageView(frame: CGRect(x: 16, y: 16, width: 92, height: 92))
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    let imageURL = URL(string: characterRequestResult?[0].image ?? "")
    imageCard.kf.setImage(with: imageURL)
    imageCard.layer.cornerRadius = 45
    imageCard.clipsToBounds = true

    infoLabel = UILabel(frame: CGRect(x: 120, y: 32, width: 226, height: 25))
    infoLabel?.text = characterRequestResult?[0].name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black

    if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (characterRequestResult?[0].id ?? 0) }) {
      favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteButton.tintColor = UIColor(named: "MainColor")
      self.deletObject = LocalDataManager.favoriteCharacters.first { $0.id == (characterRequestResult?[0].id ?? 0) }
      self.clickedTopButton = true
    } else {
      favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoriteButton.tintColor = .darkGray
      self.clickedTopButton = false
    }
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(_:)), for: .touchUpInside)

    headerView?.addSubview(favoriteButton)
    headerView?.addSubview(imageCard)
    headerView?.addSubview(infoLabel ?? UILabel())

    return headerView
  }

  private func middleHeaderConfiguration(text: String) -> UIView? {
    headerView = UIView(frame: CGRect.zero)

    infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 38))
    infoLabel?.text = text
    infoLabel?.textColor = .gray
    infoLabel?.font = .systemFont(ofSize: 14)

    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }

  // экран индикатора при подгрузках
  private func setLoadingScreen() {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height ?? 0)

    loadView.frame = CGRect(x: x, y: y, width: width, height: height)

    indicator.style = .medium
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

  @objc func favoriteButtonTap(_ sender: UIButton) {
    if clickedTopButton {
      deleteFromCache?.deleteItem(deletData: deletObject ?? NSManagedObject())
      sender.setImage(UIImage(named: "LikeButton"), for: .normal)
      sender.tintColor = .black
    } else {
      guard let saveData = characterRequestResult else { return }
      saveInCacheProtocol?.saveData(data: saveData[0])
      sender.setImage(
        UIImage(named: "LikeButtonFull"),
        for: .normal)
      sender.tintColor = UIColor(named: "MainColor")
    }
    clickedTopButton.toggle()
  }

  @IBAction func locationSegue(_ sender: UIButton) {
    let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = tableView.indexPathForRow(at: buttonPosition)
    guard let presentVC = UIStoryboard(name: "LocationUI", bundle: nil).instantiateViewController(
      withIdentifier: "LocationCardTVC") as? LocationCardTVC
    else { return }
    presentVC.locationURL.append(self.characterRequestResult?[indexPath?.row ?? 0].location?.url ?? "")
    show(presentVC, sender: sender)
  }
  @IBAction func episodesSegue(_ sender: UIButton) {
    let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = tableView.indexPathForRow(at: buttonPosition)
    guard let presentVC = UIStoryboard(name: "EpisodesUI", bundle: nil).instantiateViewController(
      withIdentifier: "EpisodesCardTVC") as? EpisodesCardTVC
    else { return }
    presentVC.episodesURL.append(self.episodeRequestResult?[indexPath?.row ?? 0].url ?? "")
    show(presentVC, sender: sender)
  }
}

extension CharacterCardTVC: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (characterSearchResult?.results.count ?? 0) - 1
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = self.collectionView?.dequeueReusableCell(
    withReuseIdentifier: "collectionCell",
    for: indexPath) as? SimilarCollectionViewCell else { return UICollectionViewCell() }
    let data = characterSearchResult?.results[indexPath.row + 1]
    let imageURL = URL(string: data?.image ?? "")

    cell.imageCollectionCell.kf.setImage(with: imageURL)
    cell.nameCollectionCell.text = data?.name

    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let presentVC = UIStoryboard(name: "CharactersUI", bundle: nil).instantiateViewController(
      withIdentifier: "CharacterCardTVC") as? CharacterCardTVC
    else { return }
    presentVC.characterURL.append(self.characterSearchResult?.results[indexPath.row + 1].url ?? "")
    show(presentVC, sender: nil)
  }
}
