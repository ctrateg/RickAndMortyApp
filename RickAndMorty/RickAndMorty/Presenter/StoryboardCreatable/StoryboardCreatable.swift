import UIKit

public protocol StoryboardCreatable: AnyObject {
  static var createFromStoryboard: UIViewController { get }
}

extension StoryboardCreatable {
  public static var createFromStoryboard: UIViewController {
    let storyboard = UIStoryboard(name: String(describing: Self.self), bundle: nil)
    guard let controller = storyboard.instantiateInitialViewController() else { fatalError("Not correct storyboard") }
    controller.modalPresentationStyle = .fullScreen
    return controller
  }
}
