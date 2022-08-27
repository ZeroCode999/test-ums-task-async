import XCTest

class ConverterTests: XCTestCase {
    /// class to test
    let batchApi: BatchApiProtocol = BatchApi(api: MockApi())
    /// test data
    let testData = TestData()
    
    /// batch request test
    func testApiRequest() {
        // TO DO: write test
        let expectation = XCTestExpectation(description: "Requesting values.")

        batchApi.request(values: testData.values) { results in
            XCTAssert(self.testData.expectedValues == results)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}

class MockApi: ApiProtocol {
    
    private let concurrentDispatch = DispatchQueue(label: "c_queue", attributes: [.concurrent])
    
    func request(value: String, completion: @escaping (String) -> Void) {
        concurrentDispatch.async {
            Thread.sleep(forTimeInterval: .random(in: 0...0.02))
            completion(Self.response(value))
        }
    }
    
    static func response(_ value: String) -> String {
        return "\(value)-converted"
    }
}

struct TestData {
    
    let values: [String]
    let expectedValues: [String]
    
    init() {
        var values = [String]()
        var expectedValues = [String]()
        for i in 0...50 {
            let value = "\(i)"
            values.append(value)
            expectedValues.append(MockApi.response(value))
        }
        self.values = values
        self.expectedValues = expectedValues
    }
}
