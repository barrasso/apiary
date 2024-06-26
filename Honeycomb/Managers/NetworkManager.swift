import Foundation
import web3swift
import Web3Core

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func getNetwork() async throws -> Web3 {
        let url = URL(string: ConfigurationManager.shared.rpcURL)!
        let web3Provider = try await Web3HttpProvider(url: url, network: nil, keystoreManager: nil)
        let web3 = Web3(provider: web3Provider)
        return web3
    }

    func pollTransactionStatus(transactionHash: String) async throws -> TransactionReceipt {
        let web3 = try await getNetwork()
        guard let txHashData = Data.fromHex(transactionHash) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid transaction hash"])
        }
        let receipt = try await TransactionPollingTask(transactionHash: txHashData, web3Instance: web3).wait()
        return receipt
    }
}
