public enum HTTPError: Error {
    case _unknown(Error)
    case dataNotAvailable
    case apiStatusError(HTTPResponse)
}
