import UIKit

class CharacterTableViewCell: UITableViewCell {
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var charactetrStatus: UILabel!
  @IBOutlet weak var characterName: UILabel!
  @IBAction func characterInfoButton(_ sender: Any) {
  }
  @IBAction func likeButton(_ sender: Any) {
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    characterIcon.layer.cornerRadius = 5
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
