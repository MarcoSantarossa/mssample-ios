import UIKit

final class PhotoDetailsViewController: UIViewController {

    private let presenter: PhotoDetailsPresenterProtocol

    init(presenter: PhotoDetailsPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        bindPresenter()
    }

    private func bindPresenter() {
        presenter.onDataDidUpdate = { [weak self] in
            guard let self = self else { return }
            self.handle(status: self.presenter.status)
        }
    }

    private func handle(status: PhotoDetailsPresenterStatus) {
        switch status {
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        handle(status: presenter.status)

        presenter.viewDidLoad()
    }
}
