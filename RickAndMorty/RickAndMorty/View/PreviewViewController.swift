import UIKit

class PreviewViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBAction func skipButton(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginTVC = storyboard.instantiateViewController(identifier: "LoginStoryboard")
    loginTVC.loadViewIfNeeded()
    loginTVC.modalPresentationStyle = .fullScreen
    present(loginTVC, animated: true)
  }
  var currentVCIndex = 0
  let images = ["hello1", "hello2", "hello3"]
  override func viewDidLoad() {
    super.viewDidLoad()
    configurePageViewController()
  }
  func configurePageViewController() {
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
    guard let startVC = detailViewControllerAt(index: currentVCIndex) else { return }
    pageVC.setViewControllers([startVC], direction: .forward, animated: true)
  }
  func detailViewControllerAt(index: Int) -> ImageViewController? {
    if index >= images.count || images.isEmpty {
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
    let imageVC = viewController as? ImageViewController
    guard var currentIndex = imageVC?.index else { return nil }
    currentVCIndex = currentIndex
    if currentIndex == 0 { return nil }
    currentIndex -= 1
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let imageViewController = viewController as? ImageViewController
    guard var currentIndex = imageViewController?.index else { return nil }
    if currentIndex == images.count { return nil }
    currentIndex += 1
    currentVCIndex = currentIndex
    return detailViewControllerAt(index: currentIndex)
  }
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [PageViewController.self])
    pageControl.currentPageIndicatorTintColor = .black
    pageControl.pageIndicatorTintColor = .white
    pageControl.numberOfPages = images.count
    for i in 0..<images.count {
      if currentVCIndex == i {
        pageControl.setIndicatorImage(UIImage(named: "fullDot"), forPage: i)
      } else {
        pageControl.setIndicatorImage(UIImage(named: "emptyDot"), forPage: i)
      }
    }
  }
}
