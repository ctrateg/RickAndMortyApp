import UIKit

class TextViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var textView: UITextView!
  private let font = UIFont.systemFont(ofSize: 15.0)
  var index: Int = 0
  var presenter: TextViewOutput?
  override func viewDidLoad() {
  super.viewDidLoad()
    self.presenter = TextPresenter(view: self, index: self.index)
    presenter?.textConfiguration(titleView: titleView, textView: textView, font: font)
    textView.textAlignment = .center
  }
}
