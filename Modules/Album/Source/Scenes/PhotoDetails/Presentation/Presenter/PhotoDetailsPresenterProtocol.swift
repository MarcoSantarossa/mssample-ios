import Foundation

protocol PhotoDetailsPresenterInput: AnyObject {
    func viewDidLoad()
}

protocol PhotoDetailsPresenterOutput: AnyObject {
    var onDataDidUpdate: (() -> Void)? { get set }
}

typealias PhotoDetailsPresenterProtocol = PhotoDetailsPresenterInput & PhotoDetailsPresenterOutput
