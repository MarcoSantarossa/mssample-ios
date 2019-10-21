import UIKit

final class PhotoCollectionViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    private let presenter: PhotoCollectionPresenterProtocol

    init(presenter: PhotoCollectionPresenterProtocol = PhotoCollectionPresenter()) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        bindPresenter()
    }

    private func bindPresenter() {
        presenter.onDataDidUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photos"

        presenter.viewDidLoad()

        let nib = UINib(nibName: PhotoCollectionCell.reusableIdentifier, bundle: nil)
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
        presenter.startLoadImage(at: indexPath.item) { data in
            guard let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                cell.update(image: image)
            }
        }

        return cell
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.cancelLoadImage(at: indexPath.item)
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
