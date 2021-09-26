protocol MenuDelegate: AnyObject {
  func toggleMenu()
}
protocol TitleNavigationDelegate: AnyObject {
  func changeTitle(_ titleName: String)
}
