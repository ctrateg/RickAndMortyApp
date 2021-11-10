import UIKit
import CoreData

protocol CharacterHeaderProtocol {
  func bottomHeaderConfiguration(cardTVC: CharacterCardTVC, collectionView: UICollectionView, tableView: UITableView) -> UIView?
  func topHeaderConfiguration(dataInput: CharacterResultsDTO, tableView: UITableView) -> UIView?
  func middleHeaderConfiguration(text: String, tableView: UITableView) -> UIView?
}

class CharacterHeaderConfigurations: CharacterHeaderProtocol {
  static var shared: CharacterHeaderConfigurations = {
    return CharacterHeaderConfigurations()
  }()
  var clickedTopButton = false
  var deleteObject: CharacterCache?
  var saveObject: CharacterResultsDTO?
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCache: LocalCacheSaveProtocol?
  private init() {
    deleteFromCache = LocalDataManager.shared
    saveInCache = LocalDataManager.shared
  }

  func topHeaderConfiguration(dataInput: CharacterResultsDTO, tableView: UITableView) -> UIView? {
    var infoLabel: UILabel?
    var headerView: UIView?

    let favoriteButton = UIButton(frame: CGRect(x: 122, y: 75, width: 160, height: 24))
    let imageCard = UIImageView(frame: CGRect(x: 16, y: 16, width: 92, height: 92))
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    let imageURL = URL(string: dataInput.image )
    imageCard.kf.setImage(with: imageURL)
    imageCard.layer.cornerRadius = 45
    imageCard.clipsToBounds = true

    infoLabel = UILabel(frame: CGRect(x: 120, y: 32, width: 226, height: 25))
    infoLabel?.text = dataInput.name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black

    favoriteButtonConfiguration(favoriteButton: favoriteButton, data: dataInput)
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(_:)), for: .touchUpInside)

    headerView?.addSubview(favoriteButton)
    headerView?.addSubview(imageCard)
    headerView?.addSubview(infoLabel ?? UILabel())
    favoriteButtonConfig(button: favoriteButton, status: dataInput.status ?? "")
    return headerView
  }

  private func favoriteButtonConfiguration(favoriteButton: UIButton, data: CharacterResultsDTO) {
    if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data.id) }) {
      favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteButton.tintColor = UIColor(named: "MainColor")
      guard let firstEqual = (LocalDataManager.favoriteCharacters.first { $0.id == (data.id) }) else { return }
      deleteObject = firstEqual
      clickedTopButton = true
    } else {
      favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoriteButton.tintColor = .darkGray
      clickedTopButton = false
    }
  }

  @objc func favoriteButtonTap(_ sender: UIButton) {
    guard let saveObj = saveObject else { return }
    if clickedTopButton {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
      sender.setImage(UIImage(named: "LikeButton"), for: .normal)
      sender.tintColor = .black
    } else {
      saveInCache?.saveData(data: saveObj)
      sender.setImage(
        UIImage(named: "LikeButtonFull"),
        for: .normal)
      sender.tintColor = UIColor(named: "MainColor")
    }
    clickedTopButton.toggle()
  }

  func middleHeaderConfiguration(text: String, tableView: UITableView) -> UIView? {
    var infoLabel: UILabel?
    var headerView: UIView?

    headerView = UIView(frame: CGRect.zero)

    infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 38))
    infoLabel?.text = text
    infoLabel?.textColor = .gray
    infoLabel?.font = .systemFont(ofSize: 14)

    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }

  func bottomHeaderConfiguration(cardTVC: CharacterCardTVC, collectionView: UICollectionView, tableView: UITableView) -> UIView? {
    var infoLabel: UILabel?
    var headerView: UIView?

    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 195))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 38))
    infoLabel?.text = "SIMILAR CHARACTERS"
    infoLabel?.textColor = .gray
    infoLabel?.font = .systemFont(ofSize: 14)

    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemGray6
    collectionView.register(
      UINib(nibName: "SimilarCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "collectionCell")

    collectionView.delegate = cardTVC
    collectionView.dataSource = cardTVC

    headerView?.addSubview(collectionView)
    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }

  private func favoriteButtonConfig(button: UIButton, status: String) {
    switch status {
    case "Dead": button.isHidden = true
    default:
      return
    }
  }
}

extension CharacterHeaderConfigurations: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
