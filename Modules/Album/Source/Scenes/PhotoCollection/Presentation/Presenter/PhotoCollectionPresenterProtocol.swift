import Foundation

protocol PhotoCollectionPresenterInput: AnyObject {
    func viewDidLoad()

    func startLoadImage(at index: Int, completion: @escaping (Data) -> Void)
    func cancelLoadImage(at index: Int)
}

protocol PhotoCollectionPresenterOutput: AnyObject {
    var mainTitle: String { get }
    var itemsCount: Int { get }

    var onDataDidUpdate: (() -> Void)? { get set }

    func title(at index: Int) -> String
}

typealias PhotoCollectionPresenterProtocol = PhotoCollectionPresenterInput & PhotoCollectionPresenterOutput
