import UIKit

final class PhotoDetailsDataView: UIView {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!

    func configure(title: String) {
        titleLabel.text = title
    }

    func update(image: UIImage) {
        loadingIndicator.removeFromSuperview()

        imageView.image = image
    }
}
