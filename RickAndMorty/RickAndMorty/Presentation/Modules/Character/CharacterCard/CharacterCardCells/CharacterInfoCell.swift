import UIKit

class CharacterInfoCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var detail: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
