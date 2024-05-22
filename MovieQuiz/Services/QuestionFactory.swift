import UIKit

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoaderProtocol
    private var movies: [MostPopularMovie] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomAskedRating = Int.random(in: 5...9)
            let text = "Рейтинг этого фильма больше чем \(randomAskedRating)?"
            let correctAnswer = rating > Float(randomAskedRating)
            
            let question = QuizQuestion(image: imageData,
                                        questionText: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies.items
                    self?.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
