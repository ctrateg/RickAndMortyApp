import UIKit

class InfoCell: UITableViewCell {
  override func awakeFromNib() {
  super.awakeFromNib()
    selectionStyle = .none
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
  super.setSelected(selected, animated: animated)
  }
}
