//
//  IAPService.swift
//  Gosio
//
//  Created by ANKIT YADAV on 07/03/21.
//

import SPAlert
import StoreKit

var delegate: controlAlert?

class IAPService: NSObject {
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = [IAPProduct.GosioPro.rawValue]
        
        let request: SKProductsRequest = SKProductsRequest(productIdentifiers: products)
        
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    var item = SKProduct()
    
    func purchase(product: IAPProduct) {
        
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first
        else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        
    }
    
    func updatePrice(product: IAPProduct) -> [String] {
        
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first
        else {return ["nil","nil","nil"]}
        return [String(describing: productToPurchase.localizedTitle),
                (String(describing: productToPurchase.price)),
                (String(describing: productToPurchase.priceLocale.currencySymbol ?? "#"))]
        
    }
    
    func restorePurchase() {
        print("Restoring Purchase")
        paymentQueue.restoreCompletedTransactions()
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
//            print(product.localizedTitle)
            let currency = "\(product.priceLocale.currencySymbol ?? "#")"
            let price = "\(product.price)"
            let LifteTimePrice = "\(currency)" + "\(price)"
            print(LifteTimePrice)
//            userDefaults?.set(LifteTimePrice, forKey: "LifetimeSubscriptionPrice")
        }
    }
    
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                break
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            print("d")
            userDefaults?.set("nil", forKey: userDefaultsKeyManager.inAppPurchaseKey)
            return "deffered"
        case .failed:
            print("f")
            purchaseFailed()
            return "failed"
        case .purchased:
            print("purchased")
            purchasedSucessfully()
            return "purchased"
        case .purchasing:
            print("purchasing")
            return "purchasing"
        case .restored:
            print("restored")
            restoredPurchase()
            return "restored"
        @unknown default:
            return "\(fatalError())"
        }
    }
}


func restoredPurchase(){
//    icloudSynced()
//    stoploader()
    userDefaults?.set("pro", forKey: userDefaultsKeyManager.inAppPurchaseKey)
    SPAlert.present(title: "Purchase Restored Successfully", message: "Please restart the app to see the changes!", preset: .done, completion: nil)
}
func purchasedSucessfully(){
//    icloudSynced()
//    stoploader()
    userDefaults?.set("pro", forKey: userDefaultsKeyManager.inAppPurchaseKey)
    SPAlert.present(title: "Purchase Successful", message: "Please restart the app to see the changes!", preset: .done, completion: nil)
}
func purchaseFailed(){
//    stoploader()
    userDefaults?.set("nil", forKey: userDefaultsKeyManager.inAppPurchaseKey)
    SPAlert.present(title: "Purchase Failed", message: "Please try again!", preset: .error, completion: nil)
}

