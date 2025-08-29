//
//  NetworkManagerTest.swift
//  MangaAppTests
//
//  Created by Никита Новицкий on 28.08.2025.
//

@testable import MangaApp
import XCTest

struct DummyModel: Codable {
    var id: String
    var name: String
}

final class NetworkManagerTest: XCTestCase {
    var sut: NetworkManager!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: config)
        sut = NetworkManager(urlSession: mockURLSession)
    }

    override func tearDown() {
        sut = nil
        expectation = nil
        super.tearDown()
    }

    func testFetch_whenStatusCodeIs200_shouldBeSuccessful() throws {
        let dummyModel = DummyModel(id: "1", name: "Test")
        let jsonData = try! JSONEncoder().encode(dummyModel)
        let request = URLRequest(url: URL(string: "https://dummy.com")!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        sut.fetch(request: request) { (result: Result<DummyModel, Error>) in
            switch result {
            case let .success(model):
                XCTAssertEqual(model.id, dummyModel.id)
            case .failure:
                XCTFail("Should not fail")
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenWrondData_shouldBeFailed() throws {
        let jsonData = Data()
        let request = URLRequest(url: URL(string: "https://dummy.com")!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        sut.fetch(request: request) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssertEqual(NetworkError.networkError, error as? NetworkError)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenHasNoData_shouldBeFailed() throws {
        let request = URLRequest(url: URL(string: "https://dummy.com")!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, nil)
        }

        sut.fetch(request: request) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssertEqual(NetworkError.networkError, error as? NetworkError)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenStatusCodeIsNot200_shouldBeFailed() throws {
        let request = URLRequest(url: URL(string: "https://dummy.com")!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, nil)
        }

        sut.fetch(request: request) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssertEqual(NetworkError.internalServerError, error as? NetworkError)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenError_shouldBeFailed() throws {
        let request = URLRequest(url: URL(string: "https://dummy.com")!)
        MockURLProtocol.requestHandler = { _ in
            throw NetworkError.networkError
        }

        sut.fetch(request: request) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssertEqual(NetworkError.networkError, error as? NetworkError)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
