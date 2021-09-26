import UIKit

class MenuButtonCell: UITableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      contentView.backgroundColor = UIColor(named: "MainColor")
      textLabel?.textColor = .white
    } else {
      contentView.backgroundColor = UIColor.white
      textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
  }
}
