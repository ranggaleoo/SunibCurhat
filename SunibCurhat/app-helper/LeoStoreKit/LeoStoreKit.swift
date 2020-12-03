//
//  LeoStoreKit.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/12/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import StoreKit

protocol LeoStoreKitDelegate: class {
    func didFetchProduct(store: LeoStoreKit, product: [LeoStoreKitProduct])
    func didFetchInvalidProduct(store: LeoStoreKit, product: [LeoStoreKitProduct.Identifier?])
    func failFetchProduct(store: LeoStoreKit)
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
        if response.invalidProductIdentifiers.count > 0 {
            let products = response.invalidProductIdentifiers.map({LeoStoreKitProduct.Identifier(rawValue: $0)})
            delegate?.didFetchInvalidProduct(store: self, product: products)
        }
        
        if response.products.count > 0 {
            let leoProducts: [LeoStoreKitProduct?] = response
                .products
                .compactMap({
                    guard let identifier = $0.productIdentifier.split(separator: ".").last else { return nil }
                    return LeoStoreKitProduct(
                        id: LeoStoreKitProduct.Identifier(rawValue: String(identifier)) ?? .example,
                        price: $0.price,
                        currencySymbol: $0.priceLocale.currencySymbol ?? "",
                        title: $0.localizedTitle,
                        desc: $0.localizedDescription,
                        item: $0)
                })
            
            var result: [LeoStoreKitProduct] = []
            for product in leoProducts {
                if let prod = product {
                    result.append(prod)
                }
            }
            if result.count > 0 {
                products = result
                delegate?.didFetchProduct(store: self, product: result)
            } else {
                delegate?.failFetchProduct(store: self)
            }
            
        } else {
            delegate?.failFetchProduct(store: self)
        }
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
