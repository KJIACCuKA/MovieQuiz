import UIKit

protocol MovieQuizViewControllerProtocol {
    func showAnswerResult(isCorrect: Bool)
    func showNextQuestionOrResults()
    func setupGame(with model: QuizQuestion)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
