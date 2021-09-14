import UIKit

class ImageViewController: UIViewController {
  @IBOutlet weak var displayImage: UIImageView!
  var previewImage: UIImage?
  var index: Int = 0
  override func viewDidLoad() {
  super.viewDidLoad()
  displayImage.contentMode = .scaleAspectFit
  displayImage.image = previewImage
  }
}
