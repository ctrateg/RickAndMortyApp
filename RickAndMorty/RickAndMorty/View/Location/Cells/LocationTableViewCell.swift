import UIKit

class LocationTableViewCell: UITableViewCell {
  @IBOutlet weak var locationName: UILabel!
  @IBAction func favoriteButton(_ sender: UIButton) {
  }
  @IBAction func sequeButton(_ sender: Any) {
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
  super.setSelected(selected, animated: animated)
    }
}
