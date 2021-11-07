import UIKit
import CoreData
class EpisodesCharactersCell: UITableViewCell {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  var clicked = false
  var deletObject: CharacterCache?
  var dataCellRequest: CharacterResultsDTO?
  override func awakeFromNib() {
    super.awakeFromNib()
    characterImage.layer.cornerRadius = 23.5
    characterImage.clipsToBounds = true
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButtonAction(_ sender: Any) {
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
}
