import UIKit

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    var view: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    let questionsAmount: Int = 10
    var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private var currentQuestion: QuizQuestion?
    
    init(view: MovieQuizViewControllerProtocol) {
        self.view = view
        self.statisticService = StatisticService()
    }
    
    func startGame() {
        view?.showLoadingIndicator()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
        questionFactory.requestNextQuestion()
    }
    
    func yesButtonClicked(viewController: MovieQuizViewControllerProtocol) {
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer, viewController: viewController)
        view?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    func noButtonClicked(viewController: MovieQuizViewControllerProtocol) {
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: !currentQuestion.correctAnswer, viewController: viewController)
        view?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    func proceedWithAnswer(isCorrect: Bool, viewController: MovieQuizViewControllerProtocol) {
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.proceedToNextQuestionOrResults(viewController: viewController)
        }
    }
    
    func proceedToNextQuestionOrResults(viewController: MovieQuizViewControllerProtocol) {
        view?.showNextQuestionOrResults()
        if currentQuestionIndex == questionsAmount - 1 {
            endGame(correctAnswers: correctAnswers, viewController: viewController)
            
        } else {
            currentQuestionIndex += 1
            startGame()
        }
    }
    
    func endGame(correctAnswers: Int, viewController: MovieQuizViewControllerProtocol) {
        
        guard let statisticService else { return }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: """
                                            Ваш результат: \(correctAnswers)/\(questionsAmount)
                                            Количество сыгранных квизов: \(statisticService.gamesCount)
                                            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                                            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                                            """,
                                    buttonText: "Сыграть ещё раз") { [weak self] in
            self?.restartGame()
        }
        
        let alertPresenter = AlertPresenter(alertModel: alertModel)
        guard let viewController = viewController as? UIViewController else { return }
        alertPresenter.showAlert(viewController: viewController)
    }
    
    func showNetworkError(message: String, viewController: MovieQuizViewControllerProtocol) {
        
        let alertModel = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            self?.restartGame()
        }
        
        let alertPresenter = AlertPresenter(alertModel: alertModel)
        guard let viewController = viewController as? UIViewController else { return }
        alertPresenter.showAlert(viewController: viewController)
        
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        startGame()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.questionText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        view?.setupGame(with: question)
    }
    
    func didLoadDataFromServer() {
        view?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        guard let view else { return }
        showNetworkError(message: error.localizedDescription, viewController: view)
    }
}
