import UIKit

final class PhotoCollectionViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    private let presenter: PhotoCollectionPresenterProtocol
    private let navigation: Navigation

    init(navigation: Navigation, presenter: PhotoCollectionPresenterProtocol = PhotoCollectionPresenter()) {
        self.presenter = presenter
        self.navigation = navigation

        super.init(nibName: nil, bundle: Bundle(for: PhotoCollectionViewController.self))

        bindPresenter()
    }

    private func bindPresenter() {
        presenter.onStateDidChange = { [weak self] state in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.handle(state: state)
            }
        }

        presenter.onImageDidLoad = { [weak self] index, data in
            DispatchQueue.main.async {
                guard
                    let self = self,
                    let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)),
                    let photoCell = cell as? PhotoCollectionCell,
                    let image = UIImage(data: data) else { return }

                photoCell.update(image: image)
            }
        }
    }

    private func handle(state: PhotoCollectionPresenterState) {
        switch state {
        case .loading:
            title = "Loading..."
        case .dataNotFound:
            title = AlbumLocalizable.localize(key: .photoCollectionTitleNotAvailable)
        case .dataAvailable:
            title = String(format: AlbumLocalizable.localize(key: .photoCollectionTitle), presenter.albumTitle)
            self.collectionView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        handle(state: presenter.state)

        registerCollectionCell()

        presenter.viewDidLoad()
    }

    private func registerCollectionCell() {
        let nib = UINib(nibName: PhotoCollectionCell.reusableIdentifier, bundle: Bundle(for: type(of: self)))
        collectionView.register(nib, forCellWithReuseIdentifier: PhotoCollectionCell.reusableIdentifier)
    }
}

extension PhotoCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reusableIdentifier, for: indexPath) as? PhotoCollectionCell else {
            fatalError("Cell at \(indexPath.item) is not a PhotoCollectionCell")
        }

        cell.configure(title: presenter.title(at: indexPath.item))

        return cell
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.itemDidShow(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.itemDidHide(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoId = presenter.photoId(at: indexPath.item)
        navigation.onPhotoDidSelect(photoId)
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Layour is not UICollectionViewFlowLayout")
        }
        let totalWidth = (flowLayout.minimumInteritemSpacing) + flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let size = (collectionView.frame.size.width - totalWidth) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension PhotoCollectionViewController {
    final class Navigation {

        let onPhotoDidSelect: (_ photoId: Int) -> Void

        init(onPhotoDidSelect: @escaping (_ photoId: Int) -> Void) {
            self.onPhotoDidSelect = onPhotoDidSelect
        }
    }
}
