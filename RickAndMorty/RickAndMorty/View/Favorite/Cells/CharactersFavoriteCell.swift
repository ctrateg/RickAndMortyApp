import UIKit

class CharactersFavoriteCell: UITableViewCell {
  @IBOutlet weak var favoriteButtonOutlet: UIButton!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var characterStatus: UILabel!
  var indexPathRow: Int?
  var dataCellRequest: CharacterCache?
  @IBAction func favoriteButtonAction(_ sender: Any) {
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    characterIcon.layer.cornerRadius = 23.5
    characterIcon.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
