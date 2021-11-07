import UIKit
import Kingfisher
import CoreData

class LocationCardTVC: UITableViewController {
  private let characterStoryboard = UIStoryboard(name: "CharactersUI", bundle: nil)
  private weak var singleRequestDelegate: SingleRequestProtocol?
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?
  var locationURL: [String] = []

  private var deletObject: LocationCache?
  private var locationRequestResult: [LocationResultsDTO]?
  private var charactersDTO: CharacterDTO?
  private var titles: [String]?
  private var headerView: UIView?
  private var infoLabel: UILabel?
  private var characterRequestResult: [CharacterResultsDTO]?
  private var cardArray: [String]?
  private var imageCharacters: [UIImage] = []
  private var clickedTopButton = false
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.saveInCacheProtocol = LocalDataManager.shared
    self.deleteFromCache = LocalDataManager.shared
    self.singleRequestDelegate = RequestServiceAPI.shared
    self.locationRequest(urlArray: locationURL)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Location Card"
    self.shareButtonConfig()
    self.titles = ["Type", "Dimension", "Date"]
  }

  private func dateFormatterConfiguration(data: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: data) else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }

  private func locationRequest(urlArray: [String]) {
    DispatchQueue.global(qos: .default).sync {
      self.singleRequestDelegate?.requestForLocation(urlArray: urlArray) { [weak self] responce in
        self?.locationRequestResult = responce
        self?.cardArray = [
          responce[0].type ,
          responce[0].dimension ,
          String(self?.dateFormatterConfiguration(data: responce[0].created) ?? "")
        ]

        self?.requestCharacters(urlArray: responce[0].residents)
        sleep(1)
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    }
  }

  private func requestCharacters(urlArray: [String]) {
    self.singleRequestDelegate?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
      self?.characterRequestResult = responce
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    default:
      return locationRequestResult?[0].residents.count ?? 0
    }
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    default:
      return 38
    }
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let presentVC = characterStoryboard.instantiateViewController(
        withIdentifier: "CharacterCardTVC") as? CharacterCardTVC
      else { return }
      presentVC.characterURL.append(self.characterRequestResult?[indexPath.row].url ?? "")
      show(presentVC, sender: nil)
    default: return
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "LocationInfoCell",
        for: indexPath) as? LocationInfoCell else { return UITableViewCell() }
      cellInfo.detailLabel.text = cardArray?[indexPath.row]
      cellInfo.titleLabel.text = titles?[indexPath.row]
      if cellInfo.detailLabel.text?.isEmpty == true {
        cellInfo.detailLabel?.text = "unknown"
      }
      return cellInfo
    default:
      guard let cellCharacter = tableView.dequeueReusableCell(
        withIdentifier: "LocationCharacterCell",
        for: indexPath) as? LocationCharacterCell else { return UITableViewCell() }
      let data = characterRequestResult?[indexPath.row]
      let imageURL = URL(string: data?.image ?? "")
      if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellCharacter.favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
        cellCharacter.favoriteButton.tintColor = UIColor(named: "MainColor")
        cellCharacter.deletObject = LocalDataManager.favoriteCharacters.first { $0.id == (data?.id ?? 0) }
        cellCharacter.clicked = true
      } else {
        cellCharacter.favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
        cellCharacter.favoriteButton.tintColor = .darkGray
        cellCharacter.clicked = false
      }
      cellCharacter.characterName.text = data?.name
      switch data?.status {
      case "Alive":
        cellCharacter.characterStatus.textColor = .green
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = false
      case "Dead":
        cellCharacter.characterStatus.textColor = .red
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = true
      default:
        cellCharacter.characterStatus.text = ""
      }
      cellCharacter.dataCellRequest = data
      cellCharacter.characterImage.kf.setImage(with: imageURL)

      return cellCharacter
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return topHeaderConfiguration()
    default:
      return middleHeaderConfiguration(text: "CHARACTERS IN LOCATION")
    }
  }

  private func topHeaderConfiguration () -> UIView? {
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 24, width: 343, height: 48))
    infoLabel?.numberOfLines = 2
    infoLabel?.text = locationRequestResult?[0].name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black

    let favoriteButton = UIButton(frame: CGRect(x: 16, y: 88, width: 160, height: 24))

    if LocalDataManager.favoriteLocation.contains(where: { $0.id == (locationRequestResult?[0].id ?? 0) }) {
      favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteButton.tintColor = UIColor(named: "MainColor")
      self.deletObject = LocalDataManager.favoriteLocation.first { $0.id == (locationRequestResult?[0].id ?? 0) }
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

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    let returnValue = [characterRequestResult?[0].name, characterRequestResult?[0].image]
    let shareController = UIActivityViewController(activityItems: returnValue as [Any], applicationActivities: nil)
    present(shareController, animated: true)
  }

  @objc func favoriteButtonTap(_ sender: UIButton) {
    if clickedTopButton {
      deleteFromCache?.deleteItem(deleteData: deletObject ?? NSManagedObject())
      sender.setImage(UIImage(named: "LikeButton"), for: .normal)
      sender.tintColor = .black
    } else {
      guard let saveData = locationRequestResult else { return }
      saveInCacheProtocol?.saveData(data: saveData[0])
      sender.setImage(
        UIImage(named: "LikeButtonFull"),
        for: .normal)
      sender.tintColor = UIColor(named: "MainColor")
    }
    clickedTopButton.toggle()
  }
}
