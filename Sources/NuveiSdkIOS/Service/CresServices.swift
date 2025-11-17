//
//  CresServices.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 13/11/25.
//

import Foundation

@MainActor
class CresServices{
    static let shared =  CresServices()
    private  init(){
        
    }
    
    
    
    func loginCres(clientId: String, clientSecret: String) async throws-> LoginResponse{
        do{
            
            let service = NuveiServices()
            let cresBody = LoginRequest(clientId: clientId, clientSecret: clientSecret)
            
            let bodyRequest = try JSONEncoder().encode(cresBody)
            
            let response: LoginResponse = try await service.makeRequest(
                methodHttp: "POST",
                endpoint: "/auth/login",
                body: bodyRequest,
                isCress: true,
                
            )
            return response
        } catch let error as ErrorModel {
            
            throw error
        } catch {
            
            throw ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            )
        }
    }
    
    
    func createReferenceCres(token: String) async throws-> referenceResponse{
        do{
            
            let service = NuveiServices()
            
            
            let response: referenceResponse = try await service.makeRequest(
                methodHttp: "POST",
                endpoint: "/cres/createreference",
                tokenCress: token,
                isCress: true
                
            )
            return response
        } catch let error as ErrorModel {
            
            throw error
        } catch {
            
            throw ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            )
        }
    }
    
    
    func consultingCres(token: String, referenceCresId: String) async throws-> CresDataResponse{
        do{
            
            let service = NuveiServices()
            
            
            let response: CresDataResponse = try await service.makeRequest(
                methodHttp: "GET",
                endpoint: "/cres/get/\(referenceCresId)",
                tokenCress: token,
                isCress: true
                
            )
            return response
        } catch let error as ErrorModel {
            
            throw error
        } catch {
            
            throw ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            )
        }
    }
    
    
    func confirmCres(token: String, referenceCresId: String) async throws-> confirmCresResponse{
        do{
            
            let service = NuveiServices()
            
            let bodyDict: [String: String] = ["id": referenceCresId]
                    let bodyData = try JSONSerialization.data(withJSONObject: bodyDict)
            let response: confirmCresResponse = try await service.makeRequest(
                methodHttp: "POST",
                endpoint: "/cres/confirm",
                body: bodyData,
                tokenCress: token,
                isCress: true
                
            )
            return response
        } catch let error as ErrorModel {
            
            throw error
        } catch {
            
            throw ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            )
        }
    }
}
