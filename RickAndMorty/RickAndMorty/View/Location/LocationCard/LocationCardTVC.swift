import UIKit
import Kingfisher

class LocationCardTVC: UITableViewController {
  private let characterStoryboard = UIStoryboard(name: "CharactersUI", bundle: nil)
  private weak var singleRequestDelegate: SingleRequestDelegate?
  var locationURL: [String] = []
  private var locationRequestResult: [LocationResultDTO]?
  private var charactersDTO: CharacterDTO?
  private var titles: [String]?
  private var headerView: UIView?
  private var infoLabel: UILabel?
  private var characterRequestResult: [CharacterResultDTO]?
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private var cardArray: [String]?
  private var imageCharacters: [UIImage] = []
  private var clickedTopButton = false
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    singleRequestDelegate = RequestServiceAPI.shared
    locationRequest(urlArray: locationURL)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Location Card"
    titles = [
      "Type",
      "Dimension",
      "Date"
    ]
  }
  func dateFormatterConfiguration() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: locationRequestResult?[0].created ?? "") else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }
  private func locationRequest(urlArray: [String]) {
    DispatchQueue.global(qos: .userInteractive).sync {
      self.singleRequestDelegate?.requestForLocation(urlArray: urlArray) { [weak self] responce in
        self?.locationRequestResult = responce
        self?.requestCharacters(urlArray: responce[0].residents)
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    }
  }
  func requestCharacters(urlArray: [String]) {
    self.singleRequestDelegate?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
      self?.characterRequestResult = responce
      self?.tableView.reloadData()
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
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cardArray = [
      locationRequestResult?[0].type ?? "",
      locationRequestResult?[0].dimension ?? "",
      dateFormatterConfiguration()
    ]
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
      cellCharacter.characterName.text = data?.name
      cellCharacter.characterStatus.text = data?.status
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
    favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
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
  // экран индикатора при подгрузках
  func setLoadingScreen() {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = tableView.bounds.midX - (width / 2)
    let y = tableView.bounds.midY - (height / 2)
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
  @IBAction func segueCharacter(_ sender: UIButton) {
    guard let characters = characterStoryboard.instantiateViewController(
      withIdentifier: "CharacterTableViewCard") as? CharacterTableViewCard else { return }
    show(characters, sender: sender)
  }
  @objc func favoriteButtonTap(_ sender: UIButton) {
    if clickedTopButton {
      sender.setImage(UIImage(named: "LikeButton"), for: .normal)
      sender.tintColor = .black
    } else {
      sender.setImage(
        UIImage(named: "LikeButtonFull"),
        for: .normal)
      sender.tintColor = UIColor(named: "mainColor")
    }
    clickedTopButton.toggle()
  }
}
