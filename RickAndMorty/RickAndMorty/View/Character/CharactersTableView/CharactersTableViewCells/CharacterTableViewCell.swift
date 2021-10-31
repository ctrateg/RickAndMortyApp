import UIKit

class CharacterTableViewCell: UITableViewCell {
  @IBOutlet weak var favoritIconOutlet: UIButton!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var charactetrStatus: UILabel!
  @IBOutlet weak var characterName: UILabel!
  private var clicked = false
  private let userCacheObject = UserCacheData.shared

  private weak var saveInCacheDelegate: UserCacheSaveDelegate?
  private weak var loadDataDelegate: UserCacheLoadDelegate?

  var dataCellRequest: CharacterDTO?
  @IBAction func likeButton(_ sender: Any) {
    if clicked {
      favoritIconOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoritIconOutlet.tintColor = .darkGray
    } else {
      favoritIconOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoritIconOutlet.tintColor = UIColor(named: "MainColor")
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
