extension UIView {

    public func addSubviewAndFill(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: subview.topAnchor),
            rightAnchor.constraint(equalTo: subview.rightAnchor),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor),
            leftAnchor.constraint(equalTo: subview.leftAnchor)
        ])
    }
}
