import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
containerView.backgroundColor = .white

PlaygroundPage.current.liveView = containerView

let scrollView = UIScrollView(frame: .zero)
scrollView.translatesAutoresizingMaskIntoConstraints = false
scrollView.backgroundColor = .green

containerView.addSubview(scrollView)

NSLayoutConstraint.activate([
    scrollView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
    scrollView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
    scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
    scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
])

let contentView = UIView()
contentView.translatesAutoresizingMaskIntoConstraints = false
contentView.backgroundColor = .red
scrollView.addSubview(contentView)

NSLayoutConstraint.activate([
    contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
    contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    contentView.heightAnchor.constraint(greaterThanOrEqualTo: containerView.heightAnchor),
    contentView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
])

let topView = UIView()
topView.translatesAutoresizingMaskIntoConstraints = false
topView.backgroundColor = .black
contentView.addSubview(topView)

NSLayoutConstraint.activate([
    topView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
    topView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    topView.topAnchor.constraint(equalTo: contentView.topAnchor),
    topView.heightAnchor.constraint(equalToConstant: 500)
])

let bottomView = UIView()
bottomView.translatesAutoresizingMaskIntoConstraints = false
bottomView.backgroundColor = .blue
contentView.addSubview(bottomView)

NSLayoutConstraint.activate([
    bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
    bottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
    bottomView.heightAnchor.constraint(equalToConstant: 100)
])


