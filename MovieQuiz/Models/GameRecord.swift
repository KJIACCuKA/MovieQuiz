import UIKit

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
