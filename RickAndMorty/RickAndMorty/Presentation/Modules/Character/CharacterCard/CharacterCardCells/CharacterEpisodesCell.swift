import UIKit
import CoreData

class CharacterEpisodesCell: UITableViewCell {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var desciption: UILabel!

  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  var clicked = false
  var deleteObject: EpisodesCache?
  var indexPathRow: Int?
  var dataCellRequest: EpisodesResultsDTO?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  @IBAction func likeButtonAction(_ sender: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
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
