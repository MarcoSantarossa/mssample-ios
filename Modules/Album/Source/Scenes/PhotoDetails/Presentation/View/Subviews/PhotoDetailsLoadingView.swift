import UIKit

final class PhotoDetailsLoadingView: UIView {

    @IBOutlet private var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        messageLabel.text = "Loading photo details data"
    }
}
