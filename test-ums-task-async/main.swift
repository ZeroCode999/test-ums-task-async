
import Foundation

protocol ApiProtocol {
    /// legacy function on string request
    func request(value: String, completion: @escaping (String) -> Void)
}

protocol BatchApiProtocol {
    /// new function on string array request
    func request(values: [String], completion: @escaping ([String]) -> Void)
}

class BatchApi: BatchApiProtocol {
    
    private let api: ApiProtocol
    
    init(api: ApiProtocol) {
        self.api = api
    }
    
    func request(values: [String], completion: @escaping ([String]) -> Void) {
        // TO DO: write a function that takes an array and returns an array by calling a legacy function.
        let dispatchGroup = DispatchGroup()
        var expectedValues = [String](repeating: "", count: values.count)
        
        for i in 0...values.count - 1 {
            dispatchGroup.enter()
            api.request(value: values[i]) { (result) in
                expectedValues[i] = result
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(expectedValues)
        }
    }
}
