//
//  ViewController.swift
//  TestMerchantApp
//
//  Created by Jorge Zapata on 20/02/18.
//  Copyright © 2018 Jorge Zapata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MCCMerchantDelegate {
    let TAG = "ViewController"
    var masterPassButton : MCCMasterpassButton?

    @IBOutlet weak var ViewButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.TAG + " DidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //initialize masterPassButton
        
        
        // Create SDK configuration object
    
        
        let configuration: MCCConfiguration = MCCConfiguration()
        configuration.enableAnalytics = true
        configuration.merchantUrlScheme = "TestMerchantApp://"
        configuration.locale = NSLocale.current
        // Start SDK initialization
        
        MCCMerchant.initializeSDK( with: configuration) { (status:[AnyHashable : Any], error: Error?) -> Void in
            
            let statusDictionary = status as? [String:AnyObject]
            let statusCode: Int = (statusDictionary?[kInitializeStateKey]?.intValue)!
            switch (MCCInitializationState(rawValue: statusCode)!) {
                
            case .started:
                //Started
                //Here you can perform other custom UI tasks like showing an activity indicator.
                print(self.TAG + " MasterpassMerchant - started" )
                break
                
            case .completed:
                //Complete
                //Here you can hide the activity indicator and add call the getMPButton or create your own button
                //self.getMasterPassButton()
                print(self.TAG + " MasterpassMerchant - Completed")
                self.masterPassButton = self.getMasterPassButton()
                self.masterPassButton?.addToview(self.ViewButton)
                
                break
                
            case .fail:
                //Error
                //On error, reset any custom UI / animations (e.g. hide the activity indicator) and if the MPButton was previously shown, hide it.
                //Inform the user an error has occurred.
                if (self.masterPassButton != nil) {
                    self.masterPassButton?.removeFromSuperview()
                }
                print(self.TAG + " MasterpassMerchant - fail")
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMasterPassButton() -> MCCMasterpassButton? {
        let masterpassButton = MCCMerchant.getMasterPassButton(self)
        return masterpassButton
    }
    
    // Used for
    
    // MARK: Build up your checkout request here
    func didGetCheckoutRequest(_ completionBlock: ((MCCCheckoutRequest) -> Bool)?) {
        
        let transactionRequest = MCCCheckoutRequest()
        
        //check merchant on-boarding process for checkoutId & cartID
        //transactionRequest.checkoutId = "c71d7dddda6a4db3af6121346de08ad9"
        transactionRequest.checkoutId = "2a68b52293f84f14bb9750e0b3515c13"
        //transactionRequest.checkoutId = "e2e39e91903a4e1d9743491448c79c11"
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
    /*func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return MCCMerchant.handleMasterpassResponse(url.absoluteString, delegate: self)
    }*/
    

}

