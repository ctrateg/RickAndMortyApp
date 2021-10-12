import UIKit

class CustomTabBar: UITabBar {
  private var tabBarWidth: CGFloat { self.bounds.width }
  private var tabBarHeight: CGFloat { self.bounds.height }
  private var centerWidth: CGFloat { self.bounds.width / 2 }
  private let circleRadius: CGFloat = 28
  private let radius: CGFloat = 36
  private var shapeLayer: CALayer?

  override func draw(_ rect: CGRect) {
    drawTabBar()
  }
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let pointIsInside = super.point(inside: point, with: event)
    if pointIsInside == false {
      for subview in subviews {
        let pointInSubview = subview.convert(point, from: self)
        if subview.point(inside: pointInSubview, with: event) {
          return true
        }
      }
    }
    return pointIsInside
  }
  private func shapePath() -> CGPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: tabBarWidth / 2 - radius, y: 0))
    path.addArc(
      withCenter: CGPoint(x: centerWidth, y: -6),
      radius: radius,
      startAngle: (9 * .pi) / 10,
      endAngle: .pi / 10,
      clockwise: false)
    path.addLine(to: CGPoint(x: tabBarWidth / 2 + radius, y: 0))
    path.addLine(to: CGPoint(x: tabBarWidth, y: 0))
    path.addLine(to: CGPoint(x: tabBarWidth, y: tabBarHeight))
    path.addLine(to: CGPoint(x: 0, y: tabBarHeight))
    path.close()
    return path.cgPath
  }
  private func drawTabBar() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = shapePath()
    shapeLayer.fillColor = UIColor(named: "MainColor")?.cgColor

    if let oldShapeLayer = self.shapeLayer {
      self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
    } else {
      self.layer.insertSublayer(shapeLayer, at: 0)
    }
    self.shapeLayer = shapeLayer
  }
}
