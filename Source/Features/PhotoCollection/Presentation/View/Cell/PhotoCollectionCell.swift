import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    static var reusableIdentifier: String {
        return String(describing: self)
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
