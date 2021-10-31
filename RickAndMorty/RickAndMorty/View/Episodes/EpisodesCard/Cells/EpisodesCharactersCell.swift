import UIKit

class EpisodesCharactersCell: UITableViewCell {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  @IBAction func favoriteButtonAction(_ sender: Any) {
  }
}
