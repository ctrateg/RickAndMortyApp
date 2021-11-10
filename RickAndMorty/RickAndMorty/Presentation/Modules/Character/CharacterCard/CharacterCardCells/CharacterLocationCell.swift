import UIKit
import CoreData

class CharacterLocationCell: UITableViewCell {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var name: UILabel!
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?
  var clicked = false
  var deleteObject: LocationCache?
  var indexPathRow: Int?
  var dataCellRequest: LocationResultsDTO?
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  @IBAction func likeButton(_ sender: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
      favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      favoriteButton.tintColor = .darkGray
    } else {
      guard let saveData = dataCellRequest else { return }
      saveInCacheProtocol?.saveData(data: saveData)
      favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      favoriteButton.tintColor = CustomColors.mainColor
    }
    clicked.toggle()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
