import Core

final class PhotoDetailsViewController: UIViewController {

    private let presenter: PhotoDetailsPresenterProtocol
    private var currentViewState: UIView?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: PhotoDetailsPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))

        bindPresenter()
    }

    private func bindPresenter() {
        presenter.onStateDidChange = { [weak self] state in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.handle(state: state)
            }
        }
    }

    private func handle(state: PhotoDetailsPresenterState) {
        currentViewState?.removeFromSuperview()

        switch state {
        case .loading:
            currentViewState = UIView.loadFromNib() as PhotoDetailsLoadingView
        case .dataNotFound:
            currentViewState = UIView.loadFromNib() as PhotoDetailsLoadingErrorView
        case .dataAvailable:
            currentViewState = createDataView()
        }

        view.addSubviewAndFill(subview: currentViewState!)
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

        handle(state: presenter.state)

        title = AlbumLocalizable.localize(key: .photoDetailsTitle)

        presenter.viewDidLoad()
    }
}
