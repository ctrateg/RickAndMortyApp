import UIKit

class StatisticsViewController: UIViewController {
  @IBOutlet weak var stackViewStatistic: UIStackView!
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var minuteLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var resetButtonOutlet: UIButton!
  private var currentDate = Int(Date().timeIntervalSince1970)
  private var startedTime = UserDefaults.standard.integer(forKey: UserDefaultKeys.firstOpenTime.rawValue)
  override func viewDidLoad() {
    super.viewDidLoad()
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      let date = (self.currentDate - self.startedTime + SceneDelegate.timeInApp)
      let hours = date / 3600 % 24
      let minutes = date / 60 % 60
      let seconds = date % 60
      self.hoursLabel.text = self.configTime(time: hours)
      self.minuteLabel.text = self.configTime(time: minutes)
      self.secondsLabel.text = self.configTime(time: seconds)
    }
  }
  @IBAction func resetButton(_ sender: Any) {
    let alertController = UIAlertController(
      title: "Reset time",
      message: "Do you want to reset time",
      preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "No", style: .default))
    alertController.addAction(UIAlertAction(title: "Yes", style: .cancel) { _ in
      SceneDelegate.timeInApp = 0
      let firstOpenTime = Int(Date().timeIntervalSince1970)
      UserDefaults.standard.set(firstOpenTime, forKey: UserDefaultKeys.firstOpenTime.rawValue)
      self.currentDate = firstOpenTime
      self.startedTime = UserDefaults.standard.integer(forKey: UserDefaultKeys.firstOpenTime.rawValue)
    })
    present(alertController, animated: true)
  }

  private func configTime(time: Int) -> String {
    let string: String
    switch time {
    case 0...9: string = "0" + String(time)
    default: string = String(time)
    }
    return string
  }
  func sanyaloh<T: Equatable>(chlen: T) {
  }
}
