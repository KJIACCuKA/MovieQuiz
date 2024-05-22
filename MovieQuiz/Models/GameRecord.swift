import UIKit

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetter(_ count: Int) -> Bool {
        correct < count
    }
}
