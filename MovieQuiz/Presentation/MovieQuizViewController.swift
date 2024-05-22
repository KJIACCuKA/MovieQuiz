import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - UIProperties
    private let yesButton = MQButton(title: "Да", accessibilityID: "Yes")
    private let noButton = MQButton(title: "Нет", accessibilityID: "No")
    private let questionTitleLabel = MQLabel(labelText: "Вопрос:", fontSize: 20, alignment: .left, fontStyle: .medium, "Question Title")
    private let counterLabel = MQLabel(labelText: "10/10", fontSize: 20, alignment: .right, fontStyle: .medium, "Index")
    private let questionLabel = MQLabel(labelText: "Рейтинг этого фильма меньше, чем 5?", fontSize: 23, alignment: .center, fontStyle: .bold, "Question")
    
    private let previewImage: UIImageView = {
        let image = UIImageView()
        image.accessibilityIdentifier = "Poster"
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = UIColor.ypWhite
        return image
    }()
    
    private let mainVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .horizontal
        return stack
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .ypGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    var presenter: MovieQuizPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setButtonTarget()
        
        presenter?.startGame()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        view.backgroundColor = UIColor.ypBlack
        view.addSubviews(mainVerticalStackView, activityIndicator)
        
        [labelsStackView, previewImage, questionLabel, buttonsStackView].forEach { mainVerticalStackView.addArrangedSubview($0) }
        
        [questionTitleLabel, counterLabel].forEach { labelsStackView.addArrangedSubview($0) }
        
        [noButton, yesButton].forEach { buttonsStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainVerticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            previewImage.widthAnchor.constraint(equalTo: previewImage.heightAnchor, multiplier: 2 / 3)
            
        ])
    }
    
    func setButtonTarget() {
        yesButton.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    @objc private func yesButtonClicked() {
        presenter?.yesButtonClicked(viewController: self)
    }
    
    @objc private func noButtonClicked() {
        presenter?.noButtonClicked(viewController: self)
    }
    
    func setupGame(with model: QuizQuestion) {
        let quiz = presenter?.convert(model: model)
        counterLabel.text = quiz?.questionNumber
        previewImage.image = quiz?.image
        questionLabel.text = quiz?.question
    }
    
    func showAnswerResult(isCorrect: Bool) {
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        [yesButton, noButton].forEach { $0.isEnabled = false }
    }
    
    func showNextQuestionOrResults() {
        previewImage.layer.borderWidth = 0
        [yesButton, noButton].forEach { $0.isEnabled = true }
    }
}
