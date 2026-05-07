import Foundation
import SwiftData
import StoreKit

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isPro: Bool = false
    var isLoading: Bool = true

    private var transactionListener: Task<Void, Never>?
    private let productIDs = [
        "com.zzoutuo.FormAI.monthly",
        "com.zzoutuo.FormAI.yearly",
        "com.zzoutuo.FormAI.lifetime"
    ]

    init() {
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            await updatePurchaseStatus()
        } catch {
            isLoading = false
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                purchasedProductIDs.insert(transaction.productID)
                isPro = true
                await transaction.finish()
                return true
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {}
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if let transaction = try? self.checkVerified(result) {
                    await self.updatePurchaseStatus()
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }

    private func updatePurchaseStatus() async {
        var purchased: Set<String> = []
        for productID in productIDs {
            if let result = await Transaction.currentEntitlement(for: productID),
               let transaction = try? checkVerified(result) {
                purchased.insert(transaction.productID)
            }
        }
        purchasedProductIDs = purchased
        isPro = !purchased.isEmpty
        isLoading = false
    }

    enum StoreError: Error {
        case failedVerification
    }

    var monthlyProduct: Product? { products.first { $0.id == "com.zzoutuo.FormAI.monthly" } }
    var yearlyProduct: Product? { products.first { $0.id == "com.zzoutuo.FormAI.yearly" } }
    var lifetimeProduct: Product? { products.first { $0.id == "com.zzoutuo.FormAI.lifetime" } }
}
