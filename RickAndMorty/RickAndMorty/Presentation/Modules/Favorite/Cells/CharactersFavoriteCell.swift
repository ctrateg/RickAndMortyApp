import UIKit

class CharactersFavoriteCell: UITableViewCell {
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var characterStatus: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    characterIcon.layer.cornerRadius = 23.5
    characterIcon.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
