//
//  MerchantCheckoutManager.swift
//  TestMerchantApp
//
//  Created by Jorge Zapata on 21/03/18.
//  Copyright © 2018 Jorge Zapata. All rights reserved.
//

import Foundation


class MerchantCheckoutManager:NSObject, MCCMerchantDelegate {
    let TAG = "MerchantCheckoutManager"

    
    //MerchantCheckoutManager.swift
    
    func getMasterPassButton() -> MCCMasterpassButton? {
        let masterpassButton = MCCMerchant.getMasterPassButton(self)
        return masterpassButton
    }
    
    // MARK: Build up your checkout request here
    func didGetCheckoutRequest(_ completionBlock: ((MCCCheckoutRequest) -> Bool)?) {
        
        let transactionRequest = MCCCheckoutRequest()
        
        //check merchant on-boarding process for checkoutId & cartID
        transactionRequest.checkoutId = "2a68b52293f84f14bb9750e0b3515c13"
        transactionRequest.cartId = "b9410f9-e5a7-4f14-9c99-ea557d6fe2e8"
        
        //amount and currency
        let amt = NSDecimalNumber(string:"75")
        let amount:MCCAmount = MCCAmount()
        amount.total = amt
        amount.currencyCode = "USD"
        transactionRequest.amount = amount
        
        //network type
        var allowedNetworkTypesSet = Set<MCCCardType>()
        allowedNetworkTypesSet.insert(MCCCardType(type: MCCCard.MASTER)!);
        transactionRequest.allowedCardTypes = allowedNetworkTypesSet
        
        //cryptogram type
        transactionRequest.cryptogramType =  MCCCryptogram(type: MCCCryptogramType.UCAF)!
        
        //shipping required
        transactionRequest.isShippingRequired = true
        
        
        // Obtenemos el valor para saber si se completo o no la transaccion
        print(self.TAG + " CompletionBlock " + completionBlock!(transactionRequest).description)
    }
    
    // MARK: delegate method to handle the checkout error
    func didReceiveCheckoutError(_ error: Error) {
        let errorObject = error as NSError
        if (errorObject.domain == MCCMerchantSDKTransactionErrorDomain) {
            //Do something with error
            
            print(self.TAG + " Error - "  + error.localizedDescription)
            //self.showErrorDialogue(error.localizedDescription, action: nil)
        } else {
            print(self.TAG + " ErrorObject - "  + errorObject.description)
            //self.showError(errorObject)
        }
    }
    
    //MARK: delegate method to handle the checkout response
    func didFinishCheckout(_ checkoutResponse: MCCCheckoutResponse) {
        let webCheckoutType : MCCResponseType = checkoutResponse.responseType
        if (webCheckoutType == .webCheckout){
            //do something
            print(self.TAG + " TransactionId - " + checkoutResponse.transactionId)
        }
    }
}
