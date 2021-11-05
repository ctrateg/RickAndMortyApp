import UIKit
import CoreData

class CharacterTableViewCell: UITableViewCell {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var characterName: UILabel!

  private weak var deleteFromCache: UserCacheDeleteProtocol?
  private weak var saveInCacheProtocol: UserCacheSaveProtocol?

  var clicked = false
  var deletObject: CharacterCache?
  var dataCellRequest: CharacterResultDTO?
  @IBAction func likeButton(_ sender: Any) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deletData: deletObject ?? NSManagedObject())
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
  override func awakeFromNib() {
    super.awakeFromNib()
    characterIcon.layer.cornerRadius = 23.5
    characterIcon.clipsToBounds = true
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
