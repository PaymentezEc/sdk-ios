import SwiftUI
import UIKit

public struct FormAddCardView: View {

    @State private var degrees: Double = 0
    @State private var flipped: Bool = false
    
    
    @State private var cardNumber: String = ""
    @State private var name: String = ""
    @State private var expires: String = ""
    @State private var cvv: String = ""
    @State private var otpCode: String = ""
    @State private var otpCodeValid: Bool = true
    
    
    @State private var errors = FormErrors()
    
    
    @State private var referenceId: String = ""
    
    @State private var cresReferenceId: String = ""
    @State private var tokenCres: String = ""
    @State private var showCresModal: Bool = false
    @State private var htmlContent: String = ""
    @State private var pollingTask: Task<Void, Never>? = nil
    
    
    @State private var currentCard = CardInfo.defaultCard()
    @State private var activeCres:Bool = false;
    @State private var validateOtp: Bool = false;
    public var onLoading: ((Bool) -> Void)?
       public var onSuccess: ((Bool, String) -> Void)?
       public var onError: ((ErrorModel) -> Void)?
    private var userId: String
    private var email: String

       
       public init(
           onLoading: ((Bool) -> Void)? = nil,
           onSuccess: ((Bool, String) -> Void)? = nil,
           onError: ((ErrorModel) -> Void)? = nil,
           userId: String,
           email: String
           
       ) {
           self.onLoading = onLoading
           self.onSuccess = onSuccess
           self.onError = onError
           self.userId = userId
           self.email = email
       }
    
    public var body: some View {
        
        ScrollView{
        VStack {
            CreditCard {
                if flipped {
                    CreditCardBack(
                        cvv: cvv,
                        colors: currentCard.gradientColors
                    )
                } else {
                    CreditCardFront(
                        cardNumber: cardNumber,
                        name: name,
                        expires: expires,
                        cardTypeImage: currentCard.icon ?? "stp_card_unknown",
                        colors: currentCard.gradientColors
                    )
                }
            }
            .padding(.vertical)
            .rotation3DEffect(
                .degrees(degrees),
                axis: (x: 0.0, y: 0.05, z: 0.0)
            )
            
            
            VStack(spacing: 10){
                
                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .textContentType(.creditCardNumber)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .onChange(of: cardNumber) { newValue in
                        currentCard = CardInfo.detect(from: newValue)
                        cardNumber = CardHelper.applyMask(to: newValue)
                    }
                    .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errors.cardNumber == nil ? Color.clear : Color.red, lineWidth: 1)
                            )
                if let error = errors.cardNumber {
                       Text(error)
                           .font(.caption)
                           .foregroundColor(.red)
                           .frame(maxWidth: .infinity, alignment: .leading)
                   }
                
                TextField("Holder name", text: $name)
                    .textCase(.uppercase)
                    .textContentType(.name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(errors.name == nil ? Color.clear : Color.red, lineWidth: 1)
                            )
                    .onChange(of: name) { newValue in
                            name = newValue.uppercased()        
                        }
                if let error = errors.name {
                       Text(error)
                           .font(.caption)
                           .foregroundColor(.red)
                           .frame(maxWidth: .infinity, alignment: .leading)
                   }
                
                
                HStack{
                    VStack{
                        TextField("Expiration", text: $expires)
                            .keyboardType(.numberPad)
                            .textContentType(.dateTime)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .onChange(of: expires) {
                                newValue in
                                expires = CardHelper.formatExpiryDate(newValue)
                            }
                            .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(errors.expires == nil ? Color.clear : Color.red, lineWidth: 1)
                                    )
                        
                        if let error = errors.expires {
                               Text(error)
                                   .font(.caption)
                                   .foregroundColor(.red)
                                   .frame(maxWidth: .infinity, alignment: .leading)
                           }
                    }
                   
                    VStack{
                        
                        TextField("CVV", text: $cvv) { (editingChanged) in
                            withAnimation {
                                degrees += 180
                                flipped.toggle()
                            }
                        }
                        
                        onCommit: {}
                            .keyboardType(.numberPad)
                            .textContentType(.creditCardNumber)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .onChange(of: cvv) { newValue in
                                
                                currentCard = CardInfo.detect(from: cardNumber)
                                if newValue.count > currentCard.cvcNumber {
                                    cvv = String(newValue.prefix(currentCard.cvcNumber))
                                    }
                                }
                            
                            .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(errors.cvv == nil ? Color.clear : Color.red, lineWidth: 1)
                                    )
                        
                        if let error = errors.cvv {
                               Text(error)
                                   .font(.caption)
                                   .foregroundColor(.red)
                                   .frame(maxWidth: .infinity, alignment: .leading)
                           }
                    }
                    
                }
                
                if validateOtp{
                    TextField("Otp Code", text: $otpCode)
                    
                        .keyboardType(.numberPad)
                        .textContentType(.creditCardNumber)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .onChange(of: otpCode) { newValue in
                                if newValue.count > 6 {
                                    otpCode = String(newValue.prefix(6))
                                }
                            }
                    if let error = errors.otp, !otpCodeValid {
                           Text(error)
                               .font(.caption)
                               .foregroundColor(.red)
                               .frame(maxWidth: .infinity, alignment: .leading)
                       }
                }
                
                
                Button(action: {
                    log("1. Usuario presionó botón")
                    if validateForm(){
                        
                        
                        Task {
                            log("2. Entró Task del botón (validateOtp=\(validateOtp))")
                            
                            if validateOtp {
                                log("3. validateOtp = true → verificar OTP")
                                try await verify(value: otpCode, type: "BY_OTP", transactionId: referenceId)
                                log("4. verify() terminó")
                            } else {
                                log("3. validateOtp = false → addCard()")
                                try await addCard()
                                log("4. addCard() terminó")
                            }
                        }
                    }
                }) {
                    Text(validateOtp ? "Verify otp" :"Add Card")
                        .frame(minWidth: 200, maxHeight: 10,)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                
            }.padding(.horizontal)
                .padding(.vertical)
            
            
        }
                     
                        
        }
        .sheet(isPresented: $showCresModal) {
            ThreeDSChallengeView(htmlContent: htmlContent) {
                Task { @MainActor in
                    showCresModal = false
                }
            }
            .onAppear {
                startPollingCres()
            }
            .onDisappear {   
                stopPolling()
            }
        }
        
    }
    
    private func validateForm() -> Bool {
        
        errors = FormErrors()
        
        if validateOtp{
            if otpCode.isEmpty{
                errors.otp = "otp is not valid"
                return false
            }
            return true
        }
        
        var valid = true
        let cleanedNumber = cardNumber
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
        
        if cleanedNumber.count < 13 {
            errors.cardNumber = "Card number is too short"
            valid = false
        }
        
        
        if !CardHelper.validateCardNumber(cleanedNumber){
            errors.cardNumber = "Number Card is not valid"
            valid = false
        }
        // Name
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.name = "Name is required"
            valid = false
        }
        
        // Expiry
        if expires.count < 5 {
            errors.expires = "Invalid expiration date"
            valid = false
        }
        
        if !CardHelper.validateExpiryDate(expires){
            errors.expires = "Invalid expiration date"
            valid = false
        }
        
        // CVV
        if cvv.count < 3 {
            errors.cvv = "CVV invalid"
            valid = false
        }
        
        
       
        
        
        return valid
    }
    
    
    
    private func addCard() async throws{
        onLoading?(true)
        do{
            
            log("A1. addCard() start")
         
            
            let env = try Environments.shared.getConfig()
            if !env.clientCode.isEmpty {
                activeCres = true
            }
            
            if activeCres{
                
                let loginCres: LoginResponse = try await CresServices.shared.loginCres(clientId: env.clientCode, clientSecret: env.clientKey)
                
                tokenCres = loginCres.access_token
                
                let referenceCres: referenceResponse = try await CresServices.shared.createReferenceCres(token: tokenCres)
                cresReferenceId = referenceCres.id
            }
            let service = NuveiServices()
            
            let threeData: ThreeDS2_data = ThreeDS2_data(term_url: "https://nuvei-cres-dev-bkh4atahdegxa8dk.eastus-01.azurewebsites.net/api/cres/save/\(cresReferenceId)", device_type: "browser");
            
            let browserInf: BrowserInfo? = await GlobalHelper.getBrowserInfo() ?? nil
            
            let extraParams: ExtraParams = ExtraParams(threeDS2_data: threeData, browser_info: browserInf ?? nil)
            
            let month = CardHelper.parseExpiryDate(expires)?.month ?? 0
            let year = CardHelper.parseExpiryDate(expires)?.year ?? 0
            let cleanedNumber = cardNumber
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "")
            let card: Card =  Card(holder_name: name, expiry_year: .int(year), expiry_month: .int(month), type: CardHelper.getCardInfo(for: cardNumber).typeCode, number: cleanedNumber, cvc: cvv,)
            let user = User(id: userId, email: email)
            let cardBody = AddCardModel(user: user, card: card, extra_params: extraParams)
            let bodyRequest = try JSONEncoder().encode(cardBody)
            print("avanza a la peticion")
            let response: AddCardResponse = try await service.makeRequest(methodHttp: "POST", endpoint: "/v2/card/add", body: bodyRequest, code: env.appCode, key: env.appKey)
            
            referenceId = response.card.transaction_reference ?? ""
            switch response.transaction.status_detail {
            case 7:
                onLoading?(false)
                if response.card.status == "valid"{
                    onSuccess?(true, "Card Added Succesfully")
                }else{
                    onSuccess?(false,"Status: \(response.card.status ?? "rejected")" )
                }
                clearAllForm()
            case 9:
                onLoading?(false)
                onSuccess?(false,"Status: \(response.card.status ?? "rejected")")
                clearAllForm()
            case 31:
                onLoading?(false)
                validateOtp = true;
            case 36:
                onLoading?(false)
                htmlContent = response.threeDS?.browser_response?.challenge_request ?? ""
                showCresModal = true
            case 35:
                try await Task.sleep(nanoseconds: 5_000_000_000)
                try await verify(value: "", type: "AUTHENTICATION_CONTINUE", transactionId: referenceId)
            default:
                onError?(ErrorModel(error: ErrorData(type: "Error in Request", help: "", description: "Status_detail: \(response.transaction.status_detail ?? 0)")))
                //onError?("Error in request")
                return
            }
    
    
            } catch let error as ErrorModel {
                onLoading?(false)
                print(error)
                onError?(error)
           } catch {
                onLoading?(false)
                print("eror aqui")
               onError?(ErrorModel(error: ErrorData(type: "Error in request", help: "", description: error.localizedDescription)))
                //onError?(error.localizedDescription)
            }
    }
    
    
    private func verify(value: String, type: String, transactionId : String)async throws{
        
        do{
            log("V1. verify() start type=\(type)")
            if type != "AUTHENTICATION_CONTINUE"{
                onLoading?(true)
            }
            
            let env = try  Environments.shared.getConfig()
            let service = NuveiServices()
            let user = User(id: "4")
            let transaction = TransactionData(id: transactionId)
            let otpRequest = OtpRequest(type: type, value: value, more_info: true, user: user, transaction: transaction)
            let bodyRequest = try JSONEncoder().encode(otpRequest)
            
        
            let  response: OtpResponse = try await service.makeRequest(
                    methodHttp: "POST",
                    endpoint: "/v2/transaction/verify",
                    body: bodyRequest,
                    code: env.serverCode,
                    key: env.serverKey
                )
            
            print("llega aqu -----------------i \(type)")
            onLoading?(false)
            switch type {
            case "BY_OTP":
                switch response.transaction.status_detail {
                case 31:
                    print("entra aqui..........")
                    otpCode = ""
                    otpCodeValid = false
                    errors.otp = "Otp Code is not valid"
                    return
                case 32:
                    validateOtp = false
                    otpCodeValid = true
                    clearAllForm()
                    onSuccess?(true, "Card added succesfully")
                case 33:
                    clearAllForm()
                    //onError?("Otp Code is not valid")
                    validateOtp = false
                default:
                    clearAllForm()
                    onError?(ErrorModel(error: ErrorData(type: "Error in Request", help: "", description: "Status_detail: \(response.transaction.status_detail ?? 0)")))
                    validateOtp = false
                    
                }
                
            case "AUTHENTICATION_CONTINUE":
                
                switch response.transaction.status {
                case "success":
                    clearAllForm()
                    onSuccess?(true, "Card Added Succesfully")
                case "pending":
                    onLoading?(false)
                    htmlContent = response.threeDS?.browser_response?.challenge_request ?? ""
                    showCresModal = true
                case "failure":
                    clearAllForm()
                    onSuccess?(false, "Status: failure")
                    
                default:
                    onError?(ErrorModel(error: ErrorData(type: "Error in Request", help: "", description: "Status_detail: \(response.transaction.status_detail ?? 0)")))
                    
                }
                
            case "BY_CRES":
                switch response.transaction.status {
                case "success":
                    clearAllForm()
                    onSuccess?(true, "Card Added Succesfully")
                case "failure":
                    clearAllForm()
                    onSuccess?(false, "Status: failure")
                default:
                    clearAllForm()
                    onError?(ErrorModel(error: ErrorData(type: "Error in Request", help: "", description: "Status_detail: \(response.transaction.status_detail ?? 0)")))
                    
                    validateOtp = false
                }
            default:
                onError?(ErrorModel(error: ErrorData(type: "Error in Request", help: "", description: "Status_detail: \(response.transaction.status_detail ?? 0)")))
               
                
            }
            
        } catch let error as ErrorModel {
            onLoading?(false)
            print(error)
            print("error del catch")
            onError?(error)
            throw error
        } catch {
            onError?(ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            ))
            onLoading?(false)
            throw ErrorModel(
                error: ErrorData(
                    type: "RequestError",
                    help: "",
                    description: error.localizedDescription
                )
            )
        }
        
    }
    
    private func startPollingCres() {
        
        pollingTask?.cancel()
        
        pollingTask = Task {
            
            
            while !Task.isCancelled {
                do {
                    let response = try await CresServices.shared.consultingCres(token: tokenCres, referenceCresId: cresReferenceId)
                    
                    
                    if let cres = response.data.cres, !cres.isEmpty
                    {
                        
                        pollingTask?.cancel()
                        
                        
                        await MainActor.run {
                            showCresModal = false
                        }
                        try? await Task.sleep(nanoseconds: 150_000_000)
                        Task {
                          _ =  try await CresServices.shared.confirmCres(token: tokenCres, referenceCresId: cresReferenceId)
                            try await verify(value: cres, type: "BY_CRES", transactionId: referenceId)
                        }
                        
                        return
                    }
                    
                } catch {
                    print("Error in ThreeDS Validation: \(error.localizedDescription)")
                }
                
                
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            }
        }
    }
    
    
    private func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }
    
    
    private func clearAllForm(){
        name = ""
        cardNumber = ""
        cvv = ""
        otpCode = ""
        expires = ""
    }
    
    func log(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"

        let time = formatter.string(from: Date())
        let thread = Thread.isMainThread ? "MAIN" : "BG"

        print("[\(time)][\(thread)] \(message)")
    }
}


struct FormErrors {
    var cardNumber: String? = nil
    var name: String? = nil
    var expires: String? = nil
    var cvv: String? = nil
    var otp: String? = nil
}


// MARK: - Preview (dentro de la librería)
struct CardInputView_Previews: PreviewProvider {
    static var previews: some View {
        FormAddCardView(userId: "4", email: "")
    }
}
