import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        loadingIndicator.isHidden = false
    }

    static var reusableIdentifier: String {
        return String(describing: self)
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func update(image: UIImage) {
        loadingIndicator.isHidden = true
        imageView.image = image
    }

}
