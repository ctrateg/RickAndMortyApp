import UIKit

protocol PreviewViewInput: AnyObject {
}

class PreviewViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var pageControl: UIPageControl!

  private let activePageIconImage = UIImage(named: "fullDot")
  private let otherPageIconImage = UIImage(named: "emptyDot")
  private let mainColor = CustomColors.mainColor

  private var currentVCIndex = 0
  var presenter: PreviewViewOutput?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = PreviewPresenter(view: self, currentVCIndex: self.currentVCIndex)
    configurePageViewController()
  }
  /// Конфигурация PageViewController
  private func configurePageViewController() {
    guard let pageVC = PageViewController.createFromStoryboard as? PageViewController else { return }
    presenter?.protocolsConfiguration(controller: pageVC, inputView: self)
    self.pageControl.backgroundColor = .white
    self.pageControl.currentPageIndicatorTintColor = mainColor
    self.pageControl.pageIndicatorTintColor = mainColor
    self.pageControl.preferredIndicatorImage = otherPageIconImage
    self.pageControl.setIndicatorImage(activePageIconImage, forPage: 0)
    self.pageControl.isUserInteractionEnabled = false
    addChild(pageVC)
    pageVC.didMove(toParent: self)

    guard let pageVCView = pageVC.view else { return }
    pageVCView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(pageVCView)
    let views: [String: Any] = ["pageView": pageVCView]

    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[pageView]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[pageView]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))

    guard let startVC = presenter?.detailViewControllerAt(
      pageControl: pageControl,
      index: self.currentVCIndex) else { return }

    pageVC.setViewControllers([startVC], direction: .forward, animated: true)
  }
  @IBAction func tapSkipButton(_ sender: UIButton) {
    show(LoginViewController.createFromStoryboard, sender: sender)
  }
}

extension PreviewViewController: PreviewViewInput {
}

extension PreviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let currentIndex = presenter?.viewControllerBeforeLogic(viewControllerBefore: viewController)
    return presenter?.detailViewControllerAt(pageControl: self.pageControl, index: currentIndex ?? 0)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let currentIndex = presenter?.viewControllerAfterLogic(
      viewControllerAfter: viewController,
      pageControl: self.pageControl)
    return presenter?.detailViewControllerAt(pageControl: pageControl, index: currentIndex ?? 0)
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    presenter?.didFinishAnimatingLogic(
      pageViewController: pageViewController,
      pageControl: self.pageControl,
      activePageIconImage: self.activePageIconImage ?? UIImage(),
      otherPageIconImage: self.otherPageIconImage ?? UIImage())
  }
}
