//
//  MangaServiceTest.swift
//  MangaAppTests
//
//  Created by Никита Новицкий on 28.08.2025.
//

@testable import MangaApp
import XCTest

enum TestData {
    static let sampleBackendManga: BackendManga = {
        let title = LocalizedText(en: "Spy x family")
        let attributes = MangaAttributes(
            title: title,
            altTitles: [LocalizedText(en: "Spy x family")],
            description: LocalizedText(en: "Spy x family"),
            year: 2023,
            contentRating: "safe",
            status: "ongoing",
            lastChapter: "10"
        )
        let coverRelationship = Relationship(id: "1", type: "cover_art")
        return BackendManga(id: "1", attributes: attributes, relationships: [coverRelationship])
    }()

//    static let sampleImageResponse: MangaEntityResponse<Image> = {
//        let imageData = Image(id: "cover123", attributes: imageAttributes)
//        return MangaEntityResponse(data: imageData)
//    }()

    static let sampleMangaCollection: MangaCollectionResponse<BackendManga> = MangaCollectionResponse(data: [sampleBackendManga])
}

final class MangaServiceTest: XCTestCase {
    var sut: MangaService!
    var expectation: XCTestExpectation!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
        mockNetworkManager = MockNetworkManager()
        sut = MangaService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        mockNetworkManager = nil
        sut = nil
        super.tearDown()
    }

    func testFetchMangas_whenSuccess_shouldCallCompletionWithMangas() {
        let mangas = TestData.sampleMangaCollection
        let image = Image(id: "1", attributes: ImageAttributes(fileName: "yor-forger.png"))
        let response = MangaEntityResponse(data: image)

        mockNetworkManager.resultsToReturn = [
            Result<MangaCollectionResponse<BackendManga>, Error>.success(mangas),
            Result<MangaEntityResponse<Image>, Error>.success(response),
        ]

        sut.fetchMangas(filter: Filter()) { result in
            switch result {
            case let .success(resMangas):
                XCTAssertEqual(resMangas.count, mangas.data.count)
                XCTAssertEqual(resMangas.first?.id, mangas.data.first?.id)
                XCTAssertEqual(resMangas.first?.title, mangas.data.first?.attributes.title.en)
                XCTAssertEqual(resMangas.first?.description, mangas.data.first?.attributes.description?.en)
                XCTAssertEqual(resMangas.first?.coverImageURL, "https://uploads.mangadex.org/covers/\(resMangas.first!.id)/\(image.attributes.fileName)")
            case .failure:
                XCTFail("Should not fail")
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetchMangaCoverImage_whenSuccess_shouldCallCompletionWithImageFileName() {
        let image = Image(id: "1", attributes: ImageAttributes(fileName: "fileName"))
        let response = MangaEntityResponse(data: image)
        mockNetworkManager.resultsToReturn = [Result<MangaEntityResponse<Image>, Error>.success(response)]

        sut.fetchMangaCoverImage(coverId: "cover_id") { result in
            switch result {
            case let .success(fileName):
                XCTAssertEqual(fileName, image.attributes.fileName)
            case .failure:
                XCTFail("Should not fail")
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
