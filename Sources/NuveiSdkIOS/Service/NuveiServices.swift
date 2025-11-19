//
//  NuveiServices.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 3/11/25.
//


import Foundation


class NuveiServices{
    private let URL_TEST = "https://ccapi-stg.paymentez.com"
    private let URL_PROD = "https://ccapi.paymentez.com"
    private let URL_CRES = "https://nuvei-cres-dev-bkh4atahdegxa8dk.eastus-01.azurewebsites.net/api"
    
    
    func makeRequest<T: Decodable>(
        methodHttp: String,
        endpoint: String,
        body: Data? = nil,
        code: String = "",
        key: String = "",
        tokenCress: String = "",
        isCress :Bool = false,
        queryParameters: [String: Any]? = nil,
    )async throws -> T{
      
        let config = try await Environments.shared.getConfig()
        
        let baseURL: String
        if isCress{
            baseURL = URL_CRES
        }else{
            baseURL = config.testMode ?  URL_TEST : URL_PROD
        }
        
        let token: String
        if isCress{
            token =  tokenCress
        }else{
            token = GlobalHelper.generateAuthToken(key: key, code: code)
        }
        
        var components = URLComponents(string: "\(baseURL)\(endpoint)")
        if let queryParameters{
            components?.queryItems = queryParameters.map{
                key, value  in URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = components?.url else{
            throw URLError(.badURL)
        }
        
        
        
        var request = URLRequest(url: url, timeoutInterval: 60)
        request.httpMethod = methodHttp
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if isCress{
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }else{
            request.addValue(token, forHTTPHeaderField: "Auth-Token")
        }
        
        if let body = body{
            request.httpBody = body
        }
        
        let (data, response) =  try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        if !(200...299).contains(httpResponse.statusCode) {
            
            if let errorResponse = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                print(errorResponse)
                throw errorResponse
            } else {
                throw URLError(.badServerResponse)
            }
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            print("METHOD: \(methodHttp)")
            print("endpoint: \(components?.url)\(components?.path)")
            print("🔵 RAW RESPONSE:\n\(jsonString)")
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
