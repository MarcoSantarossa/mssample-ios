import Foundation

enum PhotoCollectionPresenterState {
    case loading
    case dataAvailable
    case dataNotFound
}

protocol PhotoCollectionPresenterInput: AnyObject {
    func viewDidLoad()

    func startLoadImage(at index: Int, completion: @escaping (Data) -> Void)
    func cancelLoadImage(at index: Int)
}

protocol PhotoCollectionPresenterOutput: AnyObject {
    var state: PhotoCollectionPresenterState { get }

    var albumTitle: String { get }
    var itemsCount: Int { get }

    var onDataDidUpdate: (() -> Void)? { get set }

    func title(at index: Int) -> String
    func photoId(at index: Int) -> Int
}

typealias PhotoCollectionPresenterProtocol = PhotoCollectionPresenterInput & PhotoCollectionPresenterOutput
