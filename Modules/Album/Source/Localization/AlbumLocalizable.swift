import Core

final class AlbumLocalizable: Localizable {
    static var bundle = Bundle(for: AlbumLocalizable.self)

    enum LocalizableKey: String {
        case photoCollectionTitle = "photo_collection_title"
        case photoDetailsTitle = "photo_details_title"
        case photoDetailsLoadingMessage = "photo_details_loading_message"
        case photoDetailsLoadingErrorMessage = "photo_details_loading_error_message"
    }
}
