import UIKit

protocol TextViewOutput: AnyObject {
  init(view: TextViewController, index: Int)
  func textConfiguration(titleView: UITextView, textView: UITextView, font: UIFont)
}

class TextPresenter: TextViewOutput {
  weak var view: TextViewController?
  private var index: Int?

  required init(view: TextViewController, index: Int) {
    self.view = view
    self.index = index
  }
  /// Добавление текста в окна PageViewController
  /// -Parameter index: Int
  func textConfiguration(titleView: UITextView, textView: UITextView, font: UIFont) {
    var url: [String] = []
    var inputText: [String] = []
    var text = ""
    switch index {
    case 1:
      url = ["https://www.adultswim.com/videos/rick-and-morty"]
      inputText = ["Rick and Morty"]
      text = """
        The Rick and Morty API is a REST(ish) and GraphQL API based on the television show Rick and Morty.
      You will have access to about hundreds of characters, images, locations and episodes.
      The Rick and Morty API is filled with canonical information as seen on the TV show.
      """
      titleView.text = "What is this?"
      textView.attributedText = "".linkedText(text: text, inputText: inputText, urlString: url, font: font)
    case 2:
      url = ["https://axelfuhrmann.com/", "https://talitatraveler.com/"]
      inputText = ["Axel Fuhrmann", "Talita"]
      text = """
        The developers of The Rick and Morty API are Axel Fuhrmann, a guy who likes to develop things and Talita,
      the \"Rick and Morty data scientist\" and hardcore fan.
      """
      titleView.text = "Who are you?"
      textView.attributedText = "".linkedText(text: text, inputText: inputText, urlString: url, font: font)
    case 3:
      textView.font = font
      titleView.text = "Why did you build this?"
      textView.text = """
      Because we were really interested in the idea of writing an open source project and also because
      Rick and Morty is our favorite show at that moment, so why not?
      """
    case 4:
      url = ["https://nodejs.org/", "https://www.mongodb.com/", "http://json.org/", "https://m.do.co/c/2736d3ffe622", "https://netlify.com/"]
      inputText = ["Node", "MongoDB", "json", "Digital Ocean", "Netlify"]
      text = """
      The Rick and Morty API uses Node and MongoDB to serve the API.
      All the data is formatted in json and the API is hosted on Digital Ocean and Netlify.
      """
      titleView.text = "Technical stuff?"
      textView.attributedText = "".linkedText(text: text, inputText: inputText, urlString: url, font: font)
    case 5:
      url = ["https://www.adultswim.com/"]
      inputText = ["Adult Swim"]
      text = """
      Rick and Morty is created by Justin Roiland and Dan Harmon for Adult Swim.
      The data and images are used without claim of ownership and belong to their respective owners.
      The Rick and Morty API is open source and uses a BSD license.
      """
      titleView.text = "Copyright?"
      textView.attributedText = "".linkedText(text: text, inputText: inputText, urlString: url, font: font)
    default:
      url = ["https://rickandmortyapi.com"]
      inputText = ["The Rick and Morty API"]
      text = "This app uses The Rick and Morty API."
      titleView.text = "About the app"
      textView.attributedText = "".linkedText(text: text, inputText: inputText, urlString: url, font: font)
    }
  }
}
