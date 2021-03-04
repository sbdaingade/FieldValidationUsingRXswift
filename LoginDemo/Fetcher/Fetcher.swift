//
//  Fetcher.swift
//  LoginDemo
//
//  Created by Sachin Daingade on 26/02/21.
//

import Foundation
import UIKit

public class Fetcher<T:Decodable> {
    
   public enum APIResonse {
        case success(T)
        case failure(RequestError)
    }
   public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
  public enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError([String:Any])
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    
    public func loginAction(initWith user: SignIn,onComplition:@escaping (APIResonse)-> Void){
        
        let loginParameters: [String: Any] = ["email" : user.email, "password" : user.password]
        let url = URL(string: "" + "login")
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.post.rawValue
        let jsonData = try? JSONSerialization.data(withJSONObject: loginParameters, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error)
                onComplition(APIResonse.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(T.self, from: data)
                    print("responseCode : \(responseCode.statusCode)")
                    print("responseJSON : \(String(describing: result))")
                    switch responseCode.statusCode {
                    case 200:
                        onComplition(APIResonse.success(result!))
                    case 400...499:
                        onComplition(APIResonse.failure(.authorizationError(result as! [String : Any])))
                    case 500...599:
                        onComplition(APIResonse.failure(.serverError))
                    default:
                        onComplition(APIResonse.failure(.unknownError))
                        break
                    }
                } catch let parseJSONError {
                    onComplition(APIResonse.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            }
            
        }.resume()
    }
}


