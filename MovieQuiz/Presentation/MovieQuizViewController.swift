import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private weak var questionTextLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = 20
        self.imageView.clipsToBounds = true
        textLabel.font = UIFont(name: "YS Display Bold", size: 23)
        counterLabel.font = UIFont(name: "YS Display Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YS Display Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YS Display Medium", size: 20)
        questionTextLabel.font = UIFont(name: "YS Display Medium", size: 20)
        let questionFactory = QuestionFactory()
                questionFactory.setup(delegate: self)
                self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: ViewModel)
            
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    // Пользователь нажал на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // Пользователь нажал на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return questionStep
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    // Показать результат квиза
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            questionFactory.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // меняет цвет рамки после ответа пользователя
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    // показывает либо следующий вопрос, либо результат квиза
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionAmount - 1 {
            let text = correctAnswers == questionAmount ? "Поздравляем, вы ответили на 10 из 10!" : "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз"
            let viewModel = QuizResultViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            self.questionFactory.requestNextQuestion()
        }
    }
}
