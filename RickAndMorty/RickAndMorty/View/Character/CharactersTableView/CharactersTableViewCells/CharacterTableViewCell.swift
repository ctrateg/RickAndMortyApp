import UIKit

class CharacterTableViewCell: UITableViewCell {
  @IBOutlet weak var favoritIconOutlet: UIButton!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var charactetrStatus: UILabel!
  @IBOutlet weak var characterName: UILabel!
  var indexPathRow = 0
  private var clicked = false
  private let userCacheObject = UserCacheData.shared
  private weak var favoriteDelegate: UserCacheFavoriteDelage?
  private weak var saveInCacheDelegate: UserCacheSaveDelegate?
  private weak var loadDataDelegate: UserCacheLoadDelegate?
  var dataCellRequest: CharacterDTO?
  var index: Int?
  var dataCellCache: CharacterCache?
  @IBAction func likeButton(_ sender: Any) {
    if clicked {
      favoritIconOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoritIconOutlet.tintColor = .darkGray
    } else {
      favoritIconOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoritIconOutlet.tintColor = UIColor(named: "MainColor")
    }
    switch dataCellCache {
    case nil:
      saveInCacheDelegate?.saveData(data: dataCellRequest!, index: index!)
      loadDataDelegate?.loadItems { [weak self] responce in
        self?.dataCellCache = responce.last
      }
      favoriteDelegate?.saveInFavorites(data: dataCellCache!)
    default:
      favoriteDelegate?.saveInFavorites(data: dataCellCache!)
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
