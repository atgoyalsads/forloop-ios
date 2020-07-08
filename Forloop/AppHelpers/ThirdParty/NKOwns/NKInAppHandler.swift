//
//  InAppHandler.swift
//  
//
//  Created by TecOrb on 17/01/18.
//

import UIKit
import StoreKit
enum NKIAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case purchasing
    case failed
    case deferred
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .purchasing: return "Purchasing..!"
        case .failed : return "Couldn't purchased, Please try later"
        case .deferred : return "You have purchaged but you have to wait for a while"
        }
    }
}

class NKIAPHandler: NSObject {
    static let shared = NKIAPHandler()
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var completedtransaction : SKPaymentTransaction?
    //blocks

    public var purchaseStatusBlock: ((_ alertType: NKIAPHandlerAlertType,_ transactionIdentifier:String?) -> Void)?
    public var avilableProductsBlock: ((_ products: Array<SKProduct>?) -> Void)?


    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }

    public func purchaseProduct(_ product: SKProduct){
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            purchaseStatusBlock?(.disabled, nil)
        }
    }

    // MARK: - RESTORE PURCHASE
    public func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }


    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    public func fetchAvailableProducts(productIdentifiers: Array<String>){
        productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
    }
}






extension NKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        avilableProductsBlock?(response.products)
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored,self.completedtransaction?.transactionIdentifier)
    }

    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
                self.completedtransaction = transaction
                switch transaction.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    purchaseStatusBlock?(.purchased, transaction.transactionIdentifier)
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    purchaseStatusBlock?(.failed,transaction.transactionIdentifier)
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    purchaseStatusBlock?(.restored,transaction.transactionIdentifier)
                case .purchasing:
                    purchaseStatusBlock?(.purchasing,transaction.transactionIdentifier)
                case .deferred:
                    purchaseStatusBlock?(.deferred,transaction.transactionIdentifier)
                @unknown default:
                    fatalError()
            }
        }
    }
}
