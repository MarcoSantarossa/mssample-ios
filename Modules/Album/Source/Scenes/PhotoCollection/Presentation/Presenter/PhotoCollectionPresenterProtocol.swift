import Foundation

enum PhotoCollectionPresenterState {
    case loading
    case dataAvailable
    case dataNotFound
}

protocol PhotoCollectionPresenterInput: AnyObject {
    func viewDidLoad()

    func itemDidShow(at index: Int)
    func itemDidHide(at index: Int)
}

protocol PhotoCollectionPresenterOutput: AnyObject {
    var state: PhotoCollectionPresenterState { get }

    var albumTitle: String { get }
    var itemsCount: Int { get }

    var onStateDidChange: ((PhotoCollectionPresenterState) -> Void)? { get set }
    var onImageDidLoad: ((_ index: Int, _ image: Data) -> Void)? { get set }

    func title(at index: Int) -> String
    func photoId(at index: Int) -> Int
}

typealias PhotoCollectionPresenterProtocol = PhotoCollectionPresenterInput & PhotoCollectionPresenterOutput
