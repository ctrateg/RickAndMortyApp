import UIKit

class EpisodesCardTVC: UITableViewController {
  private let characterStoryboard = UIStoryboard(name: "EpisodesUI", bundle: nil)
  private weak var requestForDelegate: SingleRequestDelegate?
  private weak var getImageDelegate: GetImageDelegate?
  var episodesRequestResult: EpisodesResultDTO?
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
    requestCharacters(urlArray: episodesRequestResult?.characters ?? [])
    requestForDelegate = RequestServiceAPI.shared
    getImageDelegate = UserCacheData.shared
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Episode Card"
    cardArray = [
      dateFormatterConfiguration(),
      episodesRequestResult?.episode ?? ""
    ]
    titles = [
      "Date",
      "Code"
    ]
  }
  func dateFormatterConfiguration() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: episodesRequestResult?.created ?? "") else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }
  func requestCharacters(urlArray: [String]) {
    DispatchQueue.global(qos: .default).async {
      self.requestForDelegate?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
        self?.characterRequestResult = responce
      }
      self.dataToImage()
      DispatchQueue.main.sync {
        self.tableView.reloadData()
      }
    }
  }
  func dataToImage() {
    for i in 0..<(characterRequestResult?.count ?? 1) {
      self.imageCharacters
        .append(UIImage(
          data: self.getImageDelegate?
            .getImage(urlInput: characterRequestResult?[i].image ?? "") ?? Data()
        ) ?? UIImage())
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    default:
      return episodesRequestResult?.characters.count ?? 0
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
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "EpisodesInfoCell",
        for: indexPath) as? EpisodesInfoCell else { return UITableViewCell() }
      cellInfo.detailLabel.text = cardArray?[indexPath.row]
      cellInfo.titleLabel.text = titles?[indexPath.row]
      if cellInfo.detailLabel.text?.isEmpty == true {
        cellInfo.detailLabel?.text = "unknown"
      }
      return cellInfo
    default:
      guard let cellCharacter = tableView.dequeueReusableCell(
        withIdentifier: "EpisodesCharactersCell",
        for: indexPath) as? EpisodesCharactersCell else { return UITableViewCell() }
      let data = characterRequestResult?[indexPath.row]
      cellCharacter.characterName.text = data?.name
      cellCharacter.characterStatus.text = data?.status
      cellCharacter.characterImage.image = imageCharacters[0]

      return cellCharacter
    }
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return topHeaderConfiguration()
    default:
      return middleHeaderConfiguration(text: "CHARACTERS IN EPISODE")
    }
  }
  private func topHeaderConfiguration () -> UIView? {
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 24, width: 343, height: 48))
    infoLabel?.numberOfLines = 2
    infoLabel?.text = episodesRequestResult?.name
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
  @IBAction func segueButton(_ sender: UIButton) {
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
      sender.tintColor = UIColor(named: "MainColor")
    }
    clickedTopButton.toggle()
  }
}
