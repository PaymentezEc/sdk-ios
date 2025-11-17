// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@MainActor
public final class NuveiSdkIOS{
    public static let shared =  NuveiSdkIOS()
    private init(){}
    
    
    
    public func initEnvironments(appCode: String, appKey: String, serverCode: String, serverKey: String, clientCode: String = "", clientKey: String = "", testingMode: Bool =  true)throws{
        let config = EnvironmentConfig(appCode: appCode, appKey: appKey, serverCode: serverCode, serverKey: serverKey, clientCode: clientCode, clientKey: clientKey, testMode: testingMode)
         
        try Environments.shared.initialize(with: config)
    }
    
    
    
    public func getCards(userId: String)async throws -> CardListResponse{
 
        
        do {
            print("aqui")
            let env = try  Environments.shared.getConfig()
            let service = NuveiServices()
            
            let response: CardListResponse = try await service.makeRequest(
                methodHttp: "GET",
                endpoint: "/v2/card/list",
                code: env.serverCode,
                key: env.serverKey,
                queryParameters: ["uid": userId]
            )
            
            
            let validCards = response.cards.filter { $0.status?.lowercased() == "valid" }
            let filteredResponse = CardListResponse(cards: validCards, result_size: validCards.count)
            return filteredResponse

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
    
    public func deleteCard(tokenCard: String, userId: String )async throws->DeleteCardResponse{
        
        do{
            let env = try  Environments.shared.getConfig()
            let service = NuveiServices()
            let card = Card(token: tokenCard)
            let user = User(id: userId)
            let cardRequest = DeleteCardRequest(card: card, user: user)
            
            let bodyRequest = try JSONEncoder().encode(cardRequest)
            
            let response: DeleteCardResponse = try await service.makeRequest(methodHttp: "POST",  endpoint: "/v2/card/delete/", body: bodyRequest, code: env.serverCode, key: env.serverKey,  )
            
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
    
    
    public func processDebit(userId: String, userEmail: String, tokenCard: String, orderInfo: OrderRequest )async throws->DebitResponse{
        
        do{
            let env = try  Environments.shared.getConfig()
            let service = NuveiServices()
            let card = Card(token: tokenCard)
            let user = User(id: userId, email: userEmail)
            
            let debitRequestBody = DebitRequest(user: user, order: orderInfo, card: card)
            
            let bodyRequest = try JSONEncoder().encode(debitRequestBody)
            
            let response: DebitResponse = try await service.makeRequest(
                methodHttp: "POST",
                endpoint: "/v2/transaction/debit/",
                body: bodyRequest,
                code: env.serverCode,
                key: env.serverKey,
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
    
    
    public func processRefund(idTransaction: String = "", referenceLabel: String = "", more_info: Bool = true,amountRefund :Double  )async throws->RefundResponse{
        
        do{
            let env = try  Environments.shared.getConfig()
            let service = NuveiServices()
            
            let transactionInfo = TransactionData(id: idTransaction, reference_label: referenceLabel)
            
            let refundRequestBody = RefunRequest(transaction: transactionInfo, order: OrderRequest(amount: amountRefund), more_info: more_info)
            
            let bodyRequest = try JSONEncoder().encode(refundRequestBody)
            
            let response: RefundResponse = try await service.makeRequest(
                methodHttp: "POST",
                endpoint: "/v2/transaction/refund/",
                body: bodyRequest,
                code: env.serverCode,
                key: env.serverKey,
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
