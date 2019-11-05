import UIKit

final class PhotoDetailsDataView: UIView {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    func configure(title: String) {
        titleLabel.text = title
    }

    func update(image: UIImage) {
        imageView.image = image
    }
}
