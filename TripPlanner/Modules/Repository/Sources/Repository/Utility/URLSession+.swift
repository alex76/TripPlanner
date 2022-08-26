import Combine
import Foundation
import Utilities

extension URLSession {

    enum SessionError: Error {
        case statusCode(HTTPURLResponse)
    }

    func dataTaskPublisher<T: Decodable>(for url: URL) -> Single<T, Error> {
        self.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false
                {
                    throw SessionError.statusCode(response)
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .asSingle()
    }

}
