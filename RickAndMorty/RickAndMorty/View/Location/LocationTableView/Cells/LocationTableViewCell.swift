import UIKit
import CoreData

class LocationTableViewCell: UITableViewCell {
  @IBOutlet weak var favoritIconOutlet: UIButton!
  @IBOutlet weak var locationName: UILabel!

  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  var clicked = false
  var deletObject: LocationCache?
  var indexPathRow: Int?
  var dataCellRequest: LocationResultsDTO?
  @IBAction func favoriteButton(_ sender: UIButton) {
    deleteFromCache = LocalDataManager.shared
    saveInCacheProtocol = LocalDataManager.shared
    if clicked {
      deleteFromCache?.deleteItem(deleteData: deletObject ?? NSManagedObject())
      favoritIconOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoritIconOutlet.tintColor = .darkGray
    } else {
      guard let saveData = dataCellRequest else { return }
      saveInCacheProtocol?.saveData(data: saveData)
      favoritIconOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoritIconOutlet.tintColor = UIColor(named: "MainColor")
    }
    clicked.toggle()
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
  super.setSelected(selected, animated: animated)
  }
}
