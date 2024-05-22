import UIKit

protocol StatisticServiceProtocol {
    var totalCountCorrectAnswers: Int { get }
    var totalAmountQuestions: Int { get }
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

final class StatisticService: StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case total, bestGame, gamesCount, totalCountCorrectAnswers, totalAmountQuestions
    }
    
    var totalCountCorrectAnswers: Int {
        get {
            return userDefaults.integer(forKey: Keys.totalCountCorrectAnswers.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.totalCountCorrectAnswers.rawValue)
        }
    }
    
    var totalAmountQuestions: Int {
        get {
            return userDefaults.integer(forKey: Keys.totalAmountQuestions.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.totalAmountQuestions.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
   var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return GameRecord(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        if bestGame.isBetter(count) {
            bestGame.date = Date()
            bestGame.total = amount
            bestGame.correct = count
        }
        
        totalCountCorrectAnswers += count
        totalAmountQuestions += amount
        
        totalAccuracy = Double(totalCountCorrectAnswers) / Double(totalAmountQuestions) * 100
    }
}
