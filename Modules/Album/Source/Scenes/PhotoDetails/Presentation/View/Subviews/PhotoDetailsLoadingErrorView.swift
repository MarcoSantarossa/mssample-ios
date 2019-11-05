import UIKit

final class PhotoDetailsLoadingErrorView: UIView {

    @IBOutlet private var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        messageLabel.text = "An error occured, please try later."
    }
}
