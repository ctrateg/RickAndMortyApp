import UIKit
import CoreData

class CharacterEpisodesCell: UITableViewCell {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var desciption: UILabel!

  private weak var deleteFromCache: UserCacheDeleteProtocol?
  private weak var saveInCacheProtocol: UserCacheSaveProtocol?

  var clicked = false
  var deletObject: EpisodesCache?
  var indexPathRow: Int?
  var dataCellRequest: EpisodesResultDTO?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  @IBAction func likeButtonAction(_ sender: UIButton) {
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
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
