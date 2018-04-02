//
//  ViewController.swift
//  TestMerchantApp
//
//  Created by Jorge Zapata on 20/02/18.
//  Copyright © 2018 Jorge Zapata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let TAG = "ViewController"
    var masterPassButton : MCCMasterpassButton?
    var merchantManager : MerchantCheckoutManager?


    @IBOutlet weak var ViewButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantManager = MerchantCheckoutManager()
        
        print(self.TAG + " DidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
                self.masterPassButton = self.merchantManager?.getMasterPassButton()
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
    
    
    

}

