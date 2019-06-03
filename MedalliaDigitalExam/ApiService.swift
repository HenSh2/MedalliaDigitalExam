//
//  ApiService.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

enum MyURL: String {
    case MedalliaActions = "https://raw.githubusercontent.com/medallia-digital/Exams-Data/master/mobileData.json"
}

class ApiService {
    
    static let shared: ApiService = ApiService()
    
    private init() {
        self.conf.timeoutIntervalForRequest = 20.0
        self.conf.timeoutIntervalForResource = 20.0
    }
    
    private let conf: URLSessionConfiguration = URLSessionConfiguration.default
    
    private typealias ApiServicePrivateCompletion = (_ data: Data, _ statusCode: Int, _ error: Bool) -> ()
    
    private func request(urlString: String,
                         httpMethod: HttpMethod = .GET,
                         completion: @escaping ApiServicePrivateCompletion) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL --->>> \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        URLSession(configuration: self.conf).dataTask(with: request) { (data, response, error) in
            guard error != nil else {
                let statusCode: Int = (response as? HTTPURLResponse)?.statusCode ?? 0
                print("URL --->>> \(response?.url?.absoluteString ?? "response is nil"), statusCode --->>> \(statusCode)")
                guard let data = data else {
                    print("raw data is empty")
                    DispatchQueue.main.async {
                        completion(Data(), statusCode, false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(data, statusCode, false)
                }
                return
            }
            print("URL --->>> \(response?.url?.absoluteString ?? "response is nil"), error --->>> \(error.debugDescription)")
            DispatchQueue.main.async {
                completion(Data(), 0, true)
            }
            }.resume()
    }
    
    func requestActions(completion: @escaping ([MedalliaAction], Bool) -> ()) {
        self.request(urlString: MyURL.MedalliaActions.rawValue) { (data, _, error) in
            let actions: [MedalliaAction] = error ? [MedalliaAction]() : ActionParser.parse(data: data)
            completion(actions, error)
        }
    }

}
