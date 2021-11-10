import UIKit
import CoreData

class LocationTableViewCell: UITableViewCell, TableViewsCellInput {
  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  var presenter: TableViewsCellOutput?
  override func awakeFromNib() {
    super.awakeFromNib()
    self.presenter = TableViewsCellPresenter(view: self)
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButton(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: favoriteButton)
  }
}
