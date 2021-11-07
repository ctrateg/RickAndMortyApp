import UIKit
import CoreData

class CharacterLocationCell: UITableViewCell {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var name: UILabel!
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?
  var clicked = false
  var deletObject: LocationCache?
  var indexPathRow: Int?
  var dataCellRequest: LocationResultsDTO?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  @IBAction func likeButton(_ sender: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deleteData: deletObject ?? NSManagedObject())
      favoriteButton.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoriteButton.tintColor = .darkGray
    } else {
      guard let saveData = dataCellRequest else { return }
      saveInCacheProtocol?.saveData(data: saveData)
      favoriteButton.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteButton.tintColor = UIColor(named: "MainColor")
    }
    clicked.toggle()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
