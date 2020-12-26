//
//  Purchaser.swift
//  artermis_cool_ringtone
//
//  Created by dong ka on 9/11/20.
//  Copyright © 2020 Dong Nguyen. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit
import SwiftNotificationCenter

final class Purchaser : NSObject {
    
    //ProductsID
    static let weekly: String = Keys.weekly.appId
    static let yearly: String = Keys.yearly.appId
    //static let flashSaleWeekly: String = Keys.flashSaleWeekly.appId
    static let appSharedSecret: String = Keys.appSpecificSharedSecret.appId
    static let services: AppleReceiptValidator.VerifyReceiptURLType = .production
    
    //Kiểm tra subscription
    class func verifySubscription(productID:String) {
        let appleValidator = AppleReceiptValidator(service: services ,
                                                   sharedSecret: appSharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = productID
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    //Kiểm tra gói subscription theo group
    //Purchasing and verifying a subscription
    class func purchasingAndVerifyingSubScription(productId:String) {
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                let appleValidator = AppleReceiptValidator(service: services,
                                                           sharedSecret: appSharedSecret)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    
                    if case .success(let receipt) = result {
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productId,
                            inReceipt: receipt)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate, _):
                            print("Product is valid until \(expiryDate)")
                        case .expired(let expiryDate, _):
                            print("Product is expired since \(expiryDate)")
                        case .notPurchased:
                            print("This product has never been purchased")
                            
                        }
                    } else {
                        // receipt verification error
                    }
                }
            } else {
                // purchase error
            }
        }
    }
    
    class func verifyingSubScriptionGroup(arrs:[String],
                                          purchasedHandler:@escaping () -> Void,
                                          expiredHandler:@escaping (String) -> Void,
                                          notPurchasedHandler:@escaping () -> Void,
                                          errorHandler:@escaping () -> Void ) {
        
        let appleValidator = AppleReceiptValidator(service: services,
                                                   sharedSecret: appSharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set(arrs)
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                    purchasedHandler()
                case .expired(let expiryDate, _):
                    //          expiredHandler("\(productIds) are expired since \(expiryDate)")
                    expiredHandler("Products are expired since \(expiryDate), please purchase again!")
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                    notPurchasedHandler()
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                errorHandler()
            }
        }
    }
    
    //Restore atomic
    class func restorePurchase(success:@escaping () -> Void,
                               failure: @escaping (String?) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                //Failure
                failure("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.verifyingSubScriptionGroup(arrs: [weekly,yearly],
                                                purchasedHandler: {
                    success()
                    Defaults[\.isPurchased] = true
                    IAP_OBSERVABLE.accept(true)
                }, expiredHandler: { (str) in
                    log.debug(str)
                    failure(str)
                }, notPurchasedHandler: {
                    log.debug("Not purchase")
                    failure("Cannot restore")
                }, errorHandler: {
                    log.debug("Error")
                    failure("Cannot restore")
                })
            }
            else {
                failure("Nothing to Restore")
                print("Nothing to Restore")
            }
        }
    }
    
    //Purchase a product (given a product id)
    class func purchaseAProduct(productID:String,
                                completion:@escaping () -> Void,
                                failure:@escaping (String?) -> Void) {
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
            switch result {
            case .success:
                print("Purchase success")
                completion()
                Defaults[\.isPurchased] = true
                IAP_OBSERVABLE.accept(true)
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Purchase fail, please try again!")
                    failure("Purchase fail, please try again!")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                    failure("Not allowed to make the payment")
                case .paymentCancelled:
                    print("PaymentCancelled")
                    failure("PaymentCancelled")
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                    failure("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                    failure("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                    failure("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                    failure("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                    failure("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                    failure("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                    failure((error as NSError).localizedDescription)
                }
            }
        }
    }
       
    
    class func getInfo( ProductIds proIds:[String],
                         completed:@escaping (_ products: Set<SKProduct>) -> Void){
        SwiftyStoreKit.retrieveProductsInfo(Set(proIds))
        { result in
            if let invalidProductId = result.invalidProductIDs.first {
                log.debug("Invalid product identifier: \(invalidProductId)")
            }
            if let error = result.error {
                log.debug("error = \(error.localizedDescription)")
            }
            completed(result.retrievedProducts)
        }
    }
    /*
     - Nhiệm vụ:
     -- Complete transactions
     --- Tiến hành lấy các giá tiền từ itune
     ---- Kiểm tra các gói còn hạn hay không
     */
    
    //Complete Transactions
    class func completeTransactions(completion:@escaping () -> Void) {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break
                }
            }
        }
        print("===================Call Complete Transactions ===================")
        let dispatchGroup = DispatchGroup()
        //Verify Subscription
        dispatchGroup.enter()
        self.verifyingSubScriptionGroup(arrs: [weekly,yearly], purchasedHandler: {
            //Khi vẫn còn hạn
            //UserDefaultManager.setPurchase(bool: true)
            Defaults[\.isPurchased] = true
            IAP_OBSERVABLE.accept(true)
            dispatchGroup.leave()
            
        }, expiredHandler: { str in
            //Khi hết hạn
            log.debug(str)
            //UserDefaultManager.setPurchase(bool: false)
            Defaults[\.isPurchased] = false
            IAP_OBSERVABLE.accept(false)
            dispatchGroup.leave()
        }, notPurchasedHandler: {
            //Khi chưa trả phí
            //UserDefaultManager.setPurchase(bool: false)
            Defaults[\.isPurchased] = false
            IAP_OBSERVABLE.accept(false)
            dispatchGroup.leave()
        }, errorHandler: {
            //Lỗi (Có thể do lỗi mạng)
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main) {
            print("Multil functions complete 👍")
            print("=========================Finish Complete Transactions==================================")
            completion()
        }
    }
    
}


enum PurchaseStatus {
    case success
    case error( msg: String)
}
