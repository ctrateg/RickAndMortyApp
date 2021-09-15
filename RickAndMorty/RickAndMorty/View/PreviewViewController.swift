import UIKit

class PreviewViewController: UIViewController {
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var contentView: UIView!
  @IBAction func skipButton(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginTVC = storyboard.instantiateViewController(identifier: "LoginStoryboard")
    loginTVC.loadViewIfNeeded()
    loginTVC.modalPresentationStyle = .fullScreen
    present(loginTVC, animated: true)
  }
  let image = ImageViewController().previewImage
  var currentVCIndex = 0
  let images = ["hello1", "hello2", "hello3"]
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePageViewController()
  }
  func configurePageViewController() {
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
  func detailViewControllerAt(index: Int) -> ImageViewController? {
    if index >= images.count || images.isEmpty || index < 0 {
      return nil
    }
    guard let imageVC = storyboard?.instantiateViewController(
    withIdentifier: String(describing: ImageViewController.self)) as? ImageViewController else { return nil }
    imageVC.index = index
    imageVC.previewImage = UIImage(named: images[index])
    return imageVC
  }
}

extension PreviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentVCIndex
  }
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return images.count
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if currentVCIndex < 0 { return nil }
    let imageVC = viewController as? ImageViewController
    guard var currentIndex = imageVC?.index else { return nil }
    currentVCIndex = currentIndex
    currentIndex -= 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if currentVCIndex >= images.count { return nil }
    let imageViewController = viewController as? ImageViewController
    guard var currentIndex = imageViewController?.index else { return nil }
    currentVCIndex = currentIndex
    currentIndex += 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let pageCurrent = pageViewController.viewControllers?.first else { return }
    let nextImageVC = pageViewController.dataSource?.pageViewController(
      pageViewController,
      viewControllerAfter: pageCurrent) as? ImageViewController
    switch nextImageVC?.index {
    case 1: pageSwipe(0)
    case 2: pageSwipe(1)
    case nil: pageSwipe(2)
    default:
      pageSwipe(0)
    }
  }
  func pageSwipe(_ index: Int) {
    let activePageIcon = UIImage(named: "fullDot")
    let otherPageIcon = UIImage(named: "emptyDot")
    (0..<pageControl.numberOfPages).forEach { i in
      let pageIcon = i == index ? activePageIcon : otherPageIcon
      pageControl.setIndicatorImage(pageIcon, forPage: i)
    }
  }
}
