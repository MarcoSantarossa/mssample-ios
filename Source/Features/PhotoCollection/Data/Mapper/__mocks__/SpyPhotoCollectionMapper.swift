@testable import MSSampleiOS

final class SpyPhotoCollectionMapper: PhotoCollectionMapperProtocol {

    private(set) var mapCallsCount = 0
    private(set) var mapDtosArg: [PhotoCollectionItemDTO]!
    var forcedMap: [PhotoCollectionItem]!

    func map(dtos: [PhotoCollectionItemDTO]) -> [PhotoCollectionItem] {
        mapCallsCount += 1
        mapDtosArg = dtos

        return forcedMap
    }
}
