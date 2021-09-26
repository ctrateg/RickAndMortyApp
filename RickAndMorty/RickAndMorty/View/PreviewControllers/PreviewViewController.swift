import UIKit

class PreviewViewController: UIViewController {
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var contentView: UIView!
  private var currentVCIndex = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePageViewController()
  }
  /// Настройки PageeViewController'а
  private func configurePageViewController() {
    pageControl.backgroundColor = .white
    pageControl.currentPageIndicatorTintColor = UIColor(named: "MainColor")
    pageControl.pageIndicatorTintColor = UIColor(named: "MainColor")
    pageControl.preferredIndicatorImage = UIImage(named: "emptyDot")
    pageControl.setIndicatorImage(UIImage(named: "fullDot"), forPage: 0)
    pageControl.isUserInteractionEnabled = false
    let idintifier = String(describing: PageViewController.self)
    guard let pageVC = storyboard?.instantiateViewController(withIdentifier: idintifier) as? PageViewController else {
      return
    }
    pageVC.delegate = self
    pageVC.dataSource = self
    addChild(pageVC)
    pageVC.didMove(toParent: self)
    guard let pageVCView = pageVC.view else { return }
    pageVCView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(pageVCView)
    let views: [String: Any] = ["pageView": pageVCView]
      contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[pageView]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))
      contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[pageView]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: views))
    guard let startVC = detailViewControllerAt(index: 0) else { return }
    pageVC.setViewControllers([startVC], direction: .forward, animated: true)
  }
  /// Добавление представления с тексттом
  /// - Parameter index: Int
  /// - Returns: LabelViewController?
  private func detailViewControllerAt(index: Int) -> LabelViewController? {
    if index >= 6 || index < 0 {
      return nil
    }
    guard let labelVC = storyboard?.instantiateViewController(
    withIdentifier: String(describing: LabelViewController.self)) as? LabelViewController else { return nil }
    labelVC.index = index
    return labelVC
  }
}

extension PreviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if currentVCIndex < 0 { return nil }
    let labelVC = viewController as? LabelViewController
    guard var currentIndex = labelVC?.index else { return nil }
    currentVCIndex = currentIndex
    currentIndex -= 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if currentVCIndex >= 6 { return nil }
    let imageViewController = viewController as? LabelViewController
    guard var currentIndex = imageViewController?.index else { return nil }
    currentVCIndex = currentIndex
    currentIndex += 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let pageCurrent = pageViewController.viewControllers?.first else { return }
    let nextLabelVC = pageViewController.dataSource?.pageViewController(
      pageViewController,
      viewControllerAfter: pageCurrent) as? LabelViewController
    switch nextLabelVC?.index {
    case nil: pageSwipe(5)
    default:
      pageSwipe((nextLabelVC?.index ?? 0) - 1)
    }
  }
  /// Передвежение закрашенной точки внутри PageControl
  /// - Parameter index: Int
  private func pageSwipe(_ index: Int) {
    let activePageIcon = UIImage(named: "fullDot")
    let otherPageIcon = UIImage(named: "emptyDot")
    (0..<pageControl.numberOfPages).forEach { i in
      let pageIcon = i == index ? activePageIcon : otherPageIcon
      pageControl.setIndicatorImage(pageIcon, forPage: i)
    }
  }
}
