import UIKit

class CharacterTableViewCard: UITableViewController {
  private weak var singleRequestDelegate: SingleRequestDelegate?
  private weak var searchDellegate: RequestSerivceSearchDelegate?
  private weak var getImageDelegate: GetImageDelegate?

  var characterCache: CharacterCache?
  var characterDTO: CharacterResultDTO?

  private var cardArray: [String]?
  private var titles: [String]?
  private var headerView: UIView?
  private var infoLabel: UILabel?
  private var episodeRequestResult: [EpisodesResultDTO]?
  private var characterSearchResult: CharacterDTO?
  private var collectionView: UICollectionView?
  private var flow: UICollectionViewFlowLayout?

  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()
    let requestObject = RequestServiceAPI.shared
    searchDellegate = requestObject
    singleRequestDelegate = requestObject
    getImageDelegate = UserCacheData.shared
    self.tableView.backgroundColor = .systemGray6
    cardArray = [
      characterCache?.status ?? "",
      characterCache?.type ?? "",
      characterCache?.gender ?? "",
      dateFormatterConfiguration()
    ]
    titles = ["Status", "Type", "Gender", "Date"]
    episodesRequest(urlArray: characterCache?.episodes ?? [])
    similarCharacters(tag: characterCache?.name ?? "")
  }

  private func similarCharacters(tag: String) {
    setLoadingScreen()
    var searchItem = tag
    if let spaceRange = tag.range(of: " ") {
      searchItem.removeSubrange(spaceRange.lowerBound..<searchItem.endIndex)
    }
    DispatchQueue.global(qos: .background).sync {
      self.searchDellegate?.characterSearch(tag: searchItem) { [weak self] responce in
        self?.characterSearchResult = responce
      }
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
      }
    }
    removeLoadingScreen()
  }

  private func episodesRequest(urlArray: [String]) {
    setLoadingScreen()
    DispatchQueue.global(qos: .background).sync {
      self.singleRequestDelegate?.requestForEpisodes(urlArray: urlArray) { [weak self] responce in
        self?.episodeRequestResult = responce
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    removeLoadingScreen()
  }

  private func dateFormatterConfiguration() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: characterCache?.created ?? "") else { return "" }
    dateFormatter.dateFormat = "dd-MM-yyyy"
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
      return characterCache?.episodes?.count ?? 0
    default:
      return 0
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let indexPathRow = indexPath.row
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "CharacterInfoCell",
        for: indexPath) as? CharacterInfoCell else { return UITableViewCell() }
      cellInfo.detail.text = cardArray?[indexPathRow]
      cellInfo.title.text = titles?[indexPathRow]
      cellInfo.title.textColor = .gray
      if cellInfo.detail.text?.isEmpty == true {
        cellInfo.detail?.text = "unknown"
      }
      return cellInfo
    case 1:
      guard let cellLocation = tableView.dequeueReusableCell(
        withIdentifier: "CharacterLocationCell",
        for: indexPath) as? CharacterLocationCell else { return UITableViewCell() }
      cellLocation.name.text = characterCache?.location
      return cellLocation
    case 2:
      guard let cellEpisode = tableView.dequeueReusableCell(
        withIdentifier: "CharacterEpisodeCell",
        for: indexPath) as? CharacterEpisodesCell else { return UITableViewCell() }
      let nameEpisodes = episodeRequestResult?[indexPathRow].name
      let descition = episodeRequestResult?[indexPathRow].episode
      cellEpisode.name.text = nameEpisodes
      cellEpisode.desciption.text = descition
      return cellEpisode
    default:
      return UITableViewCell()
    }
  }

  private func episodesSubtitle(inputString: String) -> String {
    let strArray = { () -> [Character] in
      var array: [Character] = []
      let episodes = inputString
      for str in episodes {
        array.append(str)
      }
      return array
    }
    return "Season " + strArray()[2..<3] + ", " + "Episode " + strArray()[4...5]
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
    imageCard.image = UIImage(data: characterCache?.image ?? Data())
    imageCard.layer.cornerRadius = 45
    imageCard.clipsToBounds = true

    infoLabel = UILabel(frame: CGRect(x: 120, y: 32, width: 226, height: 25))
    infoLabel?.text = characterCache?.name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black

    favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)
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
}

extension CharacterTableViewCard: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (characterSearchResult?.results.count ?? 0) - 1
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = self.collectionView?.dequeueReusableCell(
    withReuseIdentifier: "collectionCell",
    for: indexPath) as? SimilarCollectionViewCell else { return UICollectionViewCell() }
    let data = characterSearchResult?.results[indexPath.row + 1]
    let dataImage = getImageDelegate?.getImage(urlInput: data?.image ?? "")

    cell.imageCollectionCell.image = UIImage(data: dataImage ?? Data())
    cell.nameCollectionCell.text = data?.name

    return cell
  }
}
