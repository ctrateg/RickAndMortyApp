import UIKit
import CoreData

protocol EpisodesHeaderProtocol: AnyObject {
  func topHeaderConfiguration(dataInput: EpisodesResultsDTO, tableView: UITableView) -> UIView?
  func middleHeaderConfiguration(text: String, tableView: UITableView) -> UIView?
}

class EpisodesHeaderConfigurations: EpisodesHeaderProtocol {
  static var shared: EpisodesHeaderConfigurations = {
    return EpisodesHeaderConfigurations()
  }()

  var clickedTopButton = false
  var deleteObject: EpisodesCache?
  var saveObject: EpisodesResultsDTO?

  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  private init () {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
  }

  func topHeaderConfiguration(dataInput: EpisodesResultsDTO, tableView: UITableView) -> UIView? {
    var infoLabel: UILabel?
    var headerView: UIView?
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 24, width: 343, height: 48))
    infoLabel?.numberOfLines = 2
    infoLabel?.text = dataInput.name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black

    let favoriteButton = UIButton(frame: CGRect(x: 16, y: 88, width: 160, height: 24))
    favoriteButtonConfiguration(favoriteButton: favoriteButton, data: dataInput)
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(_:)), for: .touchUpInside)
    headerView?.addSubview(favoriteButton)
    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
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

  private func favoriteButtonConfiguration(favoriteButton: UIButton, data: EpisodesResultsDTO) {
    if LocalDataManager.favoriteEpisodes.contains(where: { $0.id == (data.id) }) {
      favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      favoriteButton.tintColor = CustomColors.mainColor
      guard let firstEqual = (LocalDataManager.favoriteEpisodes.first { $0.id == (data.id) }) else { return }
      deleteObject = firstEqual
      clickedTopButton = true
    } else {
      favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      favoriteButton.tintColor = .darkGray
      clickedTopButton = false
    }
  }

  @objc func favoriteButtonTap(_ sender: UIButton) {
    guard let saveObj = saveObject else { return }
    if clickedTopButton {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
      sender.setImage(ImagesCell.favorite, for: .normal)
      sender.tintColor = .black
    } else {
      saveInCacheProtocol?.saveData(data: saveObj)
      sender.setImage(
        ImagesCell.favoriteSelected,
        for: .normal)
      sender.tintColor = CustomColors.mainColor
    }
    clickedTopButton.toggle()
  }
}
