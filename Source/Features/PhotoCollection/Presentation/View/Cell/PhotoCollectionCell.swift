import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = #imageLiteral(resourceName: "swift-logo")
    }

    static var reusableIdentifier: String {
        return String(describing: self)
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func update(image: UIImage) {
        imageView.image = image
    }

}
