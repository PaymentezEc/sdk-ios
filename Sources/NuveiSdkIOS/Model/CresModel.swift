//
//  CresModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 12/11/25.
//

public struct LoginRequest: Codable, Sendable{
    public let clientId: String
    public let clientSecret: String
}


public struct LoginResponse: Codable, Sendable{
    public let access_token: String
    public let token_type: String
    public let expires_in: Int
    public let name: String
}


public struct referenceResponse: Codable, Sendable{
    public let status:Bool
    public let id: String
}



struct CresDataResponse: Codable {
    let data: DataModel
    let confirmed: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.data = (try? container.decode(DataModel.self, forKey: .data))
            ?? DataModel.empty()

        self.confirmed = try container.decodeIfPresent(Bool.self, forKey: .confirmed) ?? false
    }

    enum CodingKeys: String, CodingKey {
        case data, confirmed
    }
}

struct DataModel: Codable {
    let cres: String?
    let transStatus: String?

    static func empty() -> DataModel {
        return DataModel(cres: nil, transStatus: nil)
    }
}



struct confirmCresResponse: Codable, Sendable{
    let status: Bool
    let message: String
}
