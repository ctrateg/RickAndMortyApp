import UIKit

protocol PreviewViewOutput: AnyObject {
  init(view: PreviewViewInput, currentVCIndex: Int)
  func detailViewControllerAt(pageControl: UIPageControl, index: Int) -> TextViewController?
  func viewControllerBeforeLogic(viewControllerBefore: UIViewController) -> Int
  func viewControllerAfterLogic(viewControllerAfter: UIViewController, pageControl: UIPageControl) -> Int
  func didFinishAnimatingLogic(pageViewController: UIPageViewController, pageControl: UIPageControl, activePageIconImage: UIImage, otherPageIconImage: UIImage)
  func protocolsConfiguration(controller: PageViewController, inputView: PreviewViewController)
}

class PreviewPresenter: PreviewViewOutput {
  private var currentVCIndex = 0
  weak var view: PreviewViewInput?
  required init(view: PreviewViewInput, currentVCIndex: Int) {
    self.view = view
    self.currentVCIndex = currentVCIndex
  }

  /// Создание представлений с текстом
  /// -Parameter index: Int
  /// -Returns: TextViewController
  func detailViewControllerAt(pageControl: UIPageControl, index: Int) -> TextViewController? {
    if index >= pageControl.numberOfPages || index < 0 {
      return nil
    } else {
      let textVC = TextViewController.createFromStoryboard as? TextViewController
      textVC?.index = index
      return textVC
    }
  }

  func viewControllerBeforeLogic(viewControllerBefore: UIViewController) -> Int {
    let textVC = viewControllerBefore as? TextViewController
    guard var currentIndex = textVC?.index else { return 0 }
    if currentIndex < 0 { return 0 }
    currentVCIndex = currentIndex
    currentIndex -= 1
    return currentIndex
  }

  func viewControllerAfterLogic(viewControllerAfter: UIViewController, pageControl: UIPageControl) -> Int {
    let textViewController = viewControllerAfter as? TextViewController
    guard var currentIndex = textViewController?.index else { return 0 }
    if currentIndex >= pageControl.numberOfPages { return 0 }
    currentVCIndex = currentIndex
    currentIndex += 1
    return currentIndex
  }

  func didFinishAnimatingLogic(pageViewController: UIPageViewController, pageControl: UIPageControl, activePageIconImage: UIImage, otherPageIconImage: UIImage) {
    guard let pageCurrent = pageViewController.viewControllers?.first else { return }
    let dataSource = pageViewController.dataSource
    let nextTextVC =
    dataSource?.pageViewController(pageViewController, viewControllerAfter: pageCurrent) as? TextViewController
    switch nextTextVC?.index {
    case nil:
      pageControl.currentPage = 5
    default:
      pageControl.currentPage = ((nextTextVC?.index ?? 0) - 1)
    }
    (0..<pageControl.numberOfPages).forEach { i in
      let pageIcon = i == pageControl.currentPage ? activePageIconImage : otherPageIconImage
      pageControl.setIndicatorImage(pageIcon, forPage: i)
    }
  }

  func protocolsConfiguration(controller: PageViewController, inputView: PreviewViewController) {
    controller.delegate = inputView
    controller.dataSource = inputView
  }
}
