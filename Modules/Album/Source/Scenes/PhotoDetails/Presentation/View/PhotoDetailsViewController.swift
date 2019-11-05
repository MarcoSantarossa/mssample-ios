import Core

final class PhotoDetailsViewController: UIViewController {

    private let presenter: PhotoDetailsPresenterProtocol
    private var currentViewStatus: UIView?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: PhotoDetailsPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))

        bindPresenter()
    }

    private func bindPresenter() {
        presenter.onDataDidUpdate = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.handle(status: self.presenter.status)
            }
        }
    }

    private func handle(status: PhotoDetailsPresenterStatus) {
        currentViewStatus?.removeFromSuperview()

        switch status {
        case .loading:
            currentViewStatus = UIView.loadFromNib() as PhotoDetailsLoadingView
        case .dataNotFound:
            currentViewStatus = UIView.loadFromNib() as PhotoDetailsLoadingErrorView
        case .dataAvailable:
            currentViewStatus = createDataView()
        }

        view.addSubviewAndFill(subview: currentViewStatus!)
    }

    private func createDataView() -> PhotoDetailsDataView {
        let dataView: PhotoDetailsDataView = UIView.loadFromNib()
        dataView.configure(title: presenter.photoTitle)
        presenter.getImage { [weak dataView] data in
            guard let dataView = dataView, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                dataView.update(image: image)
            }
        }
        return dataView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        handle(status: presenter.status)

        title = "Photo Details"

        presenter.viewDidLoad()
    }
}
