@testable import ActiveLabel

final class MockActiveBuilder: ActiveBuilderInterface {
    var createElementsCallCount = 0
    func createElements(type: ActiveType, from text: String, range: NSRange, filterPredicate: ActiveFilterPredicate?) -> [ElementTuple] {
        createElementsCallCount += 1
        return []
    }
    
    var createURLElementsCallCount = 0
    func createURLElements(from text: String, range: NSRange, maximumLength: Int?) -> ([ElementTuple], String) {
        createURLElementsCallCount += 1
        return ([ElementTuple](), "")
    }
    
    
}
