import UIKit
import CoreData

class EpisodesTableViewCell: UITableViewCell {
  @IBOutlet weak var episodesTitle: UILabel!
  @IBOutlet weak var episodesNumber: UILabel!
  @IBOutlet weak var favoriteIconOutlet: UIButton!

  private weak var deleteFromCache: UserCacheDeleteProtocol?
  private weak var saveInCacheProtocol: UserCacheSaveProtocol?
  var clicked = false
  var deletObject: EpisodesCache?
  var indexPathRow: Int?
  var dataCellRequest: EpisodesResultDTO?
  @IBAction func favoriteButton(_ sender: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deletData: deletObject ?? NSManagedObject())
      favoriteIconOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoriteIconOutlet.tintColor = .darkGray
    } else {
      guard let saveData = dataCellRequest else { return }
      saveInCacheProtocol?.saveData(data: saveData)
      favoriteIconOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteIconOutlet.tintColor = UIColor(named: "MainColor")
    }
    clicked.toggle()
  }
  @IBAction func sequeButton(_ sender: Any) {
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
