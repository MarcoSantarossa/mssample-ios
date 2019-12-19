@testable import Core

import XCTest

// Keep test case disabled in the scheme not to use NSCache
final class CacheTests: XCTestCase {

    private var sut: Cache<NSString, NSString>!

    override func setUp() {
        super.setUp()

        sut = Cache()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }
}

// MARK: - get/set
extension CacheTests {
    func test_get_emptyCache_returnsNil() {
        let result: NSString? = sut.get(key: "hello")

        XCTAssertNil(result)
    }

    func test_get_invalidKey_returnsNil() {
        sut.set(value: "world", key: "hello1234")

        let result: NSString? = sut.get(key: "hello")

        XCTAssertNil(result)
    }

    func test_get_validKey_returnsExpectedValue() {
        sut.set(value: "world", key: "hello")

        let result: NSString? = sut.get(key: "hello")

        XCTAssertEqual(result, "world")
    }
}
