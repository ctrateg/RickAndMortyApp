import UIKit

class LabelViewController: UIViewController {
  @IBOutlet weak var titleText: UITextView!
  @IBOutlet weak var textView: UITextView!
  var index: Int = 0
  override func viewDidLoad() {
  super.viewDidLoad()
    labelText(index)
    titleText.sizeToFit()
    textView.sizeToFit()
  }
  /// Добавление текста в определенное окно в PageController
  /// - Parameter index: Int
  private func labelText(_ index: Int) {
    var url: [String] = []
    var textInput: [String] = []
    var text = ""
    switch index {
    case 1:
      titleText.text = "What is this?"
      url = ["https://www.adultswim.com/videos/rick-and-morty"]
      textInput = ["Rick and Morty"]
      text = """
      The Rick and Morty API is a REST(ish) and GraphQL API based on the television show Rick and Morty.
      You will have access to about hundreds of characters, images, locations and episodes.
      The Rick and Morty API is filled with canonical information as seen on the TV show.
    """
      textView.attributedText = linkedText(text: text, textInput: textInput, link: url)
    case 2:
      titleText.text = "Who are you?"
      url = ["https://axelfuhrmann.com/", "https://talitatraveler.com/"]
      textInput = ["Axel Fuhrmann", "Talita"]
      text = """
        The developers of The Rick and Morty API are Axel Fuhrmann, a guy who likes to develop things and Talita,
      the \"Rick and Morty data scientist\" and hardcore fan.
      """
      textView.attributedText = linkedText(text: text, textInput: textInput, link: url)
    case 3:
      titleText.text = "Why did you build this?"
      text = """
        Because we were really interested in the idea of writing an open source project and also because
      Rick and Morty is our favorite show at that moment, so why not?
      """
      textView.text = text
    case 4:
      titleText.text = "Technical stuff?"
      url = [
        "https://nodejs.org/en/",
        "https://www.mongodb.com/",
        "https://www.json.org/json-en.html",
        "https://www.digitalocean.com/?refcode=2736d3ffe622&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=CopyPaste",
        "https://netlify.com/"
      ]
      textInput = ["Node", "MongoDB", "json", "Digital Ocean", "Netlify"]
      text = """
        The Rick and Morty API uses Node and MongoDB to serve the API.
        All the data is formatted in json and the API is hosted on Digital Ocean and Netlify.
      """
      textView.attributedText = linkedText(text: text, textInput: textInput, link: url)

    case 5:
      titleText.text = "Copyright?"
      url = ["https://www.adultswim.com/"]
      textInput = ["Adult Swim"]
      text = """
        Rick and Morty is created by Justin Roiland and Dan Harmon for Adult Swim.
        The data and images are used without claim of ownership and belong to their respective owners.
        The Rick and Morty API is open source and uses a BSD license.
      """
      textView.attributedText = linkedText(text: text, textInput: textInput, link: url)
    default:
      url = ["https://rickandmortyapi.com/"]
      textInput = ["The Rick and Morty API"]
      text = "This app uses The Rick and Morty API."
      titleText.text = "About the app"
      textView.attributedText = linkedText(text: text, textInput: textInput, link: url)
    }
  }

  /// Метод создания ссылок на определенные части текста
  /// - Parameters:
  ///   - text: String
  ///   - textInput: String
  ///   - link: URL
  /// - Returns: NSMutableAttributedString
  private func linkedText(text: String, textInput: [String], link: [String]) -> NSMutableAttributedString {
    let attributedText = NSMutableAttributedString(string: text)

    for i in 0..<link.count {
      let startPosition: Int = text.distance(
        from: text.startIndex,
        to: text.range(of: textInput[i])?.lowerBound ?? String.Index(utf16Offset: 0, in: ""))
      let lenght: Int = text.distance(
        from: text.startIndex,
        to: text.range(of: textInput[i])?.upperBound ?? String.Index(utf16Offset: 0, in: ""))
      guard let unwarpedLink = URL(string: link[i]) else { return NSMutableAttributedString(string: "") }
      attributedText.setAttributes(
        [.link: unwarpedLink],
        range: NSRange(location: startPosition, length: (lenght - startPosition)))
    }
    return attributedText
  }
}
