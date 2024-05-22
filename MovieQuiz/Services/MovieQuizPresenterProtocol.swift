import UIKit

protocol MovieQuizPresenterProtocol {
    var currentQuestionIndex: Int { get set }
    var questionsAmount: Int { get }
    init(view: MovieQuizViewControllerProtocol)
    func yesButtonClicked(viewController: MovieQuizViewControllerProtocol)
    func noButtonClicked(viewController: MovieQuizViewControllerProtocol)
    func endGame(correctAnswers: Int, viewController: MovieQuizViewControllerProtocol)
    func proceedWithAnswer(isCorrect: Bool, viewController: MovieQuizViewControllerProtocol)
    func proceedToNextQuestionOrResults(viewController: MovieQuizViewControllerProtocol)
    func showNetworkError(message: String, viewController: MovieQuizViewControllerProtocol)
    func startGame()
    func convert(model: QuizQuestion) -> QuizStepViewModel
}
