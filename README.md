
# Nuvei SDK iOS
SDK oficial de Nuvei para iOS, desarrollado en Swift, que permite:


- Inicializar el entorno (sandbox / producción)
- Listar tarjetas
- Eliminar tarjetas
- Procesar pagos débito
- Realizar reembolsos
- Agregar tarjetas mediante UI en SwiftUI


## 📥 Integración en el proyecto
### 1️⃣ Descargar el repositorio
Clona o descarga el repositorio del SDK:
```code
git clone REPOSITORIO
```

### 2️⃣ Agregar al proyecto Xcode

1. Abre tu proyecto en Xcode
2. Arrastra la carpeta del SDK al proyecto
3. Marca Copy items if needed
4. Asegúrate de agregarlo al Target correcto



### 3️⃣ Importar el SDK
```code
import NuveiSdkIOS
```

## ⚙️ Inicialización del entorno
#### ⚠️ Obligatorio inicializar el entorno antes de consumir cualquier servicio.

```code 
Task {
    try NuveiSdkIOS.shared.initEnvironments(
        appCode: APP_CODE,
        appKey: APP_KEY,
        serverCode: SERVER_CODE,
        serverKey: SERVER_KEY,
        clientCode: CLIENT_CODE,
        clientKey: CLIENT_KEY,
        testingMode: false
    )

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    withAnimation {
        isInitialized = true
    }
}
```

### 🧩 Clase principal: NuveiSdkIOS

```swift
@MainActor
public final class NuveiSdkIOS {

    public static let shared = NuveiSdkIOS()
    private init() {}

    public func initEnvironments(
        appCode: String,
        appKey: String,
        serverCode: String,
        serverKey: String,
        clientCode: String = "",
        clientKey: String = "",
        testingMode: Bool = true
    ) throws {
        let config = EnvironmentConfig(
            appCode: appCode,
            appKey: appKey,
            serverCode: serverCode,
            serverKey: serverKey,
            clientCode: clientCode,
            clientKey: clientKey,
            testMode: testingMode
        )

        try Environments.shared.initialize(with: config)
    }

    public func getCards(userId: String) async throws -> CardListResponse {
        let env = try Environments.shared.getConfig()
        let service = NuveiServices()

        let response: CardListResponse = try await service.makeRequest(
            methodHttp: "GET",
            endpoint: "/v2/card/list",
            code: env.serverCode,
            key: env.serverKey,
            queryParameters: ["uid": userId]
        )

        let validCards = response.cards.filter {
            $0.status?.lowercased() == "valid"
        }

        return CardListResponse(
            cards: validCards,
            result_size: validCards.count
        )
    }

    public func deleteCard(
        tokenCard: String,
        userId: String
    ) async throws -> DeleteCardResponse {
        let env = try Environments.shared.getConfig()
        let service = NuveiServices()

        let request = DeleteCardRequest(
            card: Card(token: tokenCard),
            user: User(id: userId)
        )

        let body = try JSONEncoder().encode(request)

        return try await service.makeRequest(
            methodHttp: "POST",
            endpoint: "/v2/card/delete/",
            body: body,
            code: env.serverCode,
            key: env.serverKey
        )
    }

    public func processDebit(
        userId: String,
        userEmail: String,
        tokenCard: String,
        orderInfo: OrderRequest
    ) async throws -> DebitResponse {
        let env = try Environments.shared.getConfig()
        let service = NuveiServices()

        let request = DebitRequest(
            user: User(id: userId, email: userEmail),
            order: orderInfo,
            card: Card(token: tokenCard)
        )

        let body = try JSONEncoder().encode(request)

        return try await service.makeRequest(
            methodHttp: "POST",
            endpoint: "/v2/transaction/debit/",
            body: body,
            code: env.serverCode,
            key: env.serverKey
        )
    }

    public func processRefund(
        idTransaction: String = "",
        referenceLabel: String = "",
        more_info: Bool = true,
        amountRefund: Double
    ) async throws -> RefundResponse {
        let env = try Environments.shared.getConfig()
        let service = NuveiServices()

        let request = RefunRequest(
            transaction: TransactionData(
                id: idTransaction,
                reference_label: referenceLabel
            ),
            order: OrderRequest(amount: amountRefund),
            more_info: more_info
        )

        let body = try JSONEncoder().encode(request)

        return try await service.makeRequest(
            methodHttp: "POST",
            endpoint: "/v2/transaction/refund/",
            body: body,
            code: env.serverCode,
            key: env.serverKey
        )
    }
}
```

### 📋 Listar tarjetas
```code
private func loadCards() async {
    isLoading = true
    errorMessage = nil

    do {
        let data = try await NuveiSdkIOS.shared.getCards(userId: "4")
        listCards = data.cards
    } catch let error as ErrorModel {
        errorMessage = error.error.description
    } catch {
        errorMessage = error.localizedDescription
    }

    isLoading = false
}
```

### ❌ Eliminar tarjeta

```code
private func deleteCard(token: String, userId: String) async {
    isLoading = true

    do {
        let response = try await NuveiSdkIOS.shared.deleteCard(
            tokenCard: token,
            userId: userId
        )
        print(response.message)
        await loadCards()
    } catch let error as ErrorModel {
        errorMessage = error.error.description
    } catch {
        errorMessage = error.localizedDescription
    }

    isLoading = false
}
```

### 💳 Pago Débito


```
private func processDebit() async {
    guard let selected = cardSelected else { return }

    isLoading = true
    errorMessage = nil

    let orderInfo = OrderRequest(
        amount: 5.19,
        description: "Pedido ObservaGYE",
        dev_reference: "referencia-123",
        vat: 0.65,
        taxable_amount: 4.35,
        tax_percentage: 15.0
    )

    do {
        let response = try await NuveiSdkIOS.shared.processDebit(
            userId: "4",
            userEmail: "erick.guillen@nuvei.com",
            tokenCard: selected.token ?? "",
            orderInfo: orderInfo
        )

        debitResponse = response
        navigateToResponse = true
    } catch let error as ErrorModel {
        errorMessage = error.error.description
    } catch {
        errorMessage = error.localizedDescription
    }

    isLoading = false
}
```

### 🧩 UI: Agregar tarjeta (SwiftUI)
El SDK incluye una UI reutilizable para agregar tarjetas.


- 📱 Vista de ejemplo

```swift
import SwiftUI
import NuveiSdkIOS

struct AddCardView: View {

    @State private var isLoading = false
    @State private var message = ""
    @State private var showingAlert = false

    var body: some View {
        ZStack {

            FormAddCardView(
                onLoading: { value in
                    isLoading = value
                },
                onSuccess: { response, mess in
                    message = mess
                    showingAlert = true
                },
                onError: { errorMsg in
                    message = errorMsg.error.description
                    showingAlert = true
                },
                userId: "4",
                email: "erick.guillen@nuvei.com"
            )
            .disabled(isLoading)

            if isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("Process...")
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
            }
        }
        .alert(message, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    AddCardView()
}
```



### 🔄 Flujo del formulario

Usuario ingresa datos de tarjeta
```code
onLoading(true)
Registro en Nuvei
Error → onError


Éxito → onSuccess


onLoading(false)

```

### ⚠️ Manejo de errores
Todos los métodos pueden lanzar:
```code
ErrorModel
error.error.type
error.error.help
error.error.description
```
