// Check https://stackoverflow.com/questions/46200027/uilabel-wrong-word-wrap-in-ios-11

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 274.0, height: 36.0))
containerView.backgroundColor = .yellow

PlaygroundPage.current.liveView = containerView

var addressLabel: UILabel = {
    let addressLabel = UILabel()
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.font = UIFont.systemFont(ofSize: 14)
    addressLabel.textColor = .black
    addressLabel.lineBreakMode = .byWordWrapping
    addressLabel.numberOfLines = 0
    addressLabel.textAlignment = .left
    addressLabel.text = "Viamonte 5356, Mendoza, Mendoza, Argentina"
    addressLabel.backgroundColor = .red
    return addressLabel
}()

containerView.addSubview(addressLabel)

NSLayoutConstraint.activate([
    addressLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
    addressLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
    addressLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
    addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
])


