//
//  LeoStoreKit.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/12/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import StoreKit

protocol LeoStoreKitDelegate: class {
    func didFetchProduct(store: LeoStoreKit)
    func didBuyProduct(store: LeoStoreKit)
}

class LeoStoreKit: NSObject {
    private var products: [LeoStoreKitProduct] = []
    weak var delegate: LeoStoreKitDelegate?
    
    func fetchProducts(identifiers: Set<String>? = nil) {
        let products = identifiers != nil ? identifiers ?? Set(arrayLiteral: "tes") : Set(LeoStoreKitProduct.Identifier.allCases.map({ $0.get() }))
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    }
    
    func buy(identifier: LeoStoreKitProduct.Identifier) {
        guard
            let product = products.filter({ $0.id == identifier }).first,
            SKPaymentQueue.canMakePayments()
        else { fetchProducts(); return }
        
        let payment = SKPayment(product: product.item)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func get(product: LeoStoreKitProduct.Identifier) -> LeoStoreKitProduct? {
        return products.filter({ $0.id == product }).first
    }
}

extension LeoStoreKit: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let leoProducts = response
            .products
            .map({
                    LeoStoreKitProduct(
                        id: LeoStoreKitProduct.Identifier(rawValue: $0.productIdentifier) ?? .removeads,
                        price: "\($0.price)",
                        title: $0.localizedTitle,
                        desc: $0.localizedDescription,
                        item: $0)
            })
        products = leoProducts
        delegate?.didFetchProduct(store: self)
    }
}

extension LeoStoreKit: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
                
            case .deferred, .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                delegate?.didBuyProduct(store: self)
                
            @unknown default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }
        }
    }
}
