import UIKit

protocol MoviesLoaderProtocol {
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoaderProtocol {
    
    private let networkClient: NetworkRouting
    private let decoder = JSONDecoder()
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesUrl: URL {
            guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
    
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try decoder.decode(MostPopularMovies.self, from: data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

