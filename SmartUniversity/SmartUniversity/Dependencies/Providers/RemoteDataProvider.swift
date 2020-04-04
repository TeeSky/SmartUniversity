//
//  RemoteDataProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

final class RemoteDataProvider {

    static let shared = RemoteDataProvider()

    let urlSessionProvider: URLSessionProviding

    init(urlSessionProvider: URLSessionProviding = URLSession.shared) {
        self.urlSessionProvider = urlSessionProvider
    }

    func fetchJSONData<JSONData: Decodable>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void
    ) {
        guard let url = URL(string: info.jsonURLString) else { return completion(nil, .invalidURLString) }

        urlSessionProvider.dataTask(with: url) { data, _, _ in // FIXME: Implement URLResponse and Error
            guard let data = data else { return completion(nil, .noData)}
            do {
                let response = try JSONDecoder().decode(JSONData.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, .parsingError)
            }
        }.resume()
    }
}

extension RemoteDataProvider: QRPointsProviding {
}