import UIKit
import CoreData

protocol TableViewsCellOutput: AnyObject {
  init(view: TableViewsCellInput)
  func tapFavoriteButton(favoriteButton: UIButton)
  func statusCase(status: String, characterStatus: UILabel, favoriteButton: UIButton)
  func cellClicked(clicked: Bool)
  func cellDeleteObject(deleteObject: NSManagedObject)
  func cellDataRequest(dataCellRequest: Codable)
}
protocol TableViewsCellInput: AnyObject {
}

class TableViewsCellPresenter: TableViewsCellOutput {
  private var view: TableViewsCellInput?
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  private var clicked = false
  private var deleteObject: NSManagedObject?
  private var dataCellRequest: Codable?

  required init(view: TableViewsCellInput) {
    self.view = view
  }

  func tapFavoriteButton(favoriteButton: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
      favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      favoriteButton.tintColor = .darkGray
    } else {
      switch dataCellRequest {
      case is CharacterResultsDTO:
        guard let saveData = dataCellRequest as? CharacterResultsDTO else { return }
        saveInCacheProtocol?.saveData(data: saveData)
      case is EpisodesResultsDTO:
        guard let saveData = dataCellRequest as? EpisodesResultsDTO else { return }
        saveInCacheProtocol?.saveData(data: saveData)
      default:
        guard let saveData = dataCellRequest as? LocationResultsDTO else { return }
        saveInCacheProtocol?.saveData(data: saveData)
      }
      favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      favoriteButton.tintColor = CustomColors.mainColor
      favoriteButton.pulseAnimatin(inputButton: favoriteButton)
    }
    clicked.toggle()
  }

  func statusCase(status: String, characterStatus: UILabel, favoriteButton: UIButton) {
    switch status {
    case "Alive":
      characterStatus.textColor = .green
      characterStatus.text = "\u{2022}" + status
      favoriteButton.isHidden = false
    case "Dead":
      characterStatus.textColor = .red
      characterStatus.text = "\u{2022}" + status
      favoriteButton.isHidden = true
    default:
      characterStatus.text = ""
      favoriteButton.isHidden = false
    }
  }

  func cellClicked(clicked: Bool) {
    self.clicked = clicked
  }

  func cellDeleteObject(deleteObject: NSManagedObject) {
    self.deleteObject = deleteObject
  }

  func cellDataRequest(dataCellRequest: Codable) {
    self.dataCellRequest = dataCellRequest
  }
}
