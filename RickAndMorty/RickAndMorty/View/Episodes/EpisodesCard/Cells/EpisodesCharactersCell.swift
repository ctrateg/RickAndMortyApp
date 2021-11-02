import UIKit

class EpisodesCharactersCell: UITableViewCell {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    characterImage.layer.cornerRadius = 23.5
    characterImage.clipsToBounds = true
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButtonAction(_ sender: Any) {
  }
}
