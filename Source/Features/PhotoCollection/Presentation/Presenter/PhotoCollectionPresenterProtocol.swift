import Foundation

protocol PhotoCollectionPresenterInput: AnyObject {
    func viewDidLoad()

    func startLoadImage(at index: Int, completion: (Data) -> Void)
    func cancelLoadImage(at index: Int)
}

protocol PhotoCollectionPresenterOutput: AnyObject {
    var itemsCount: Int { get }

    var onDataDidUpdate: (() -> Void)? { get set }
}

typealias PhotoCollectionPresenterProtocol = PhotoCollectionPresenterInput & PhotoCollectionPresenterOutput
