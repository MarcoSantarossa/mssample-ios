import Foundation

enum PhotoDetailsPresenterStatus {
    case loading
    case dataAvailable
    case dataNotFound
}

protocol PhotoDetailsPresenterInput: AnyObject {
    func viewDidLoad()
}

protocol PhotoDetailsPresenterOutput: AnyObject {
    var onDataDidUpdate: (() -> Void)? { get set }

    var status: PhotoDetailsPresenterStatus { get }

    var photoTitle: String { get }

    func getImage(completion: @escaping (Data) -> Void)
}

typealias PhotoDetailsPresenterProtocol = PhotoDetailsPresenterInput & PhotoDetailsPresenterOutput
