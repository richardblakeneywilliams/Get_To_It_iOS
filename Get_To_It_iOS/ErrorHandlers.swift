//
//  ErrorHandlers.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 12/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit

//Firebase Auth Error Handling
public func handleFirebaseAuthErrors(email: String, error: Error) -> UIAlertController{
    var alertDescription: String = ""
        SVProgressHUD.dismiss()
        //Deal with all the fucking errors.
        if let errCode = FIRAuthErrorCode(rawValue: error._code){
            
            switch errCode {
                
            case .errorCodeWeakPassword:
                alertDescription = "That password is to weak! Please try again. Make sure the password has at least one capital letter and a couple of numbers"
            case .errorCodeTooManyRequests:
                alertDescription = "To many requests have been made from this device. Try again or contact support"
            case .errorCodeWrongPassword:
                alertDescription = "Wrong password!"
            case .errorCodeUserNotFound:
                alertDescription = "Email: \(email) was not found in the system"
            case .errorCodeInvalidEmail:
                alertDescription = "invalid email"
            case .errorCodeEmailAlreadyInUse:
                alertDescription = "Email is already in use, try another or log in with it"
            case .errorCodeAccountExistsWithDifferentCredential:
                alertDescription = "This email is already been used to register to Get To It. Its possible you used Facebook to sign up!"
            case .errorCodeNetworkError:
                alertDescription = "No Connection, try re-connecting to the internet!"
            case .errorCodeUserDisabled:
                alertDescription = "This account has been disabled. Contact Get To It support"
            default:
                print("Create User Error: \(error)")
            }
        }
        
        let alertController = UIAlertController(title: "Error", message: alertDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController .addAction(action)
        return alertController
    
}

//Facebook Error Handling. 
public func handleFacebookSDKErrors(error: Error) -> UIAlertController{
    var alertDescription: String = ""
    SVProgressHUD.dismiss()
    //Deal with all the fucking errors.
    if let errCode = FBSDKErrorCode(rawValue: error._code) {
        
        switch errCode {
            
        case .networkErrorCode:
            alertDescription = "No Connection, try re-connecting to the internet!"
        case .browserUnavailableErrorCode:
            alertDescription = "Browser unavailable"
        case .unknownErrorCode:
            alertDescription = "Unknown error occured"
        default:
            print("\(error)")
        }
    }
    
    if let loginErrCode = FBSDKLoginErrorCode(rawValue: error._code){
        
        switch loginErrCode {
        case .passwordChangedErrorCode :
            alertDescription = "Looks like your Facebook password has changed. Please log in again"
        case .unconfirmedUserErrorCode:
            alertDescription = "You haven't confirmed your Facebook account. Please confirm your account with Facebook before using Log In With Facebook"
        case .userCheckpointedErrorCode:
            alertDescription = "You must log into your Facebook account on the Facebook website/App to continue"
        case .userMismatchErrorCode:
            alertDescription = "Failure to request new permissions because the user has changed."
        case .unknownErrorCode:
            alertDescription = "Unknown error occured"
        default:
            print("\(error)")
        }
    }
    
    
    let alertController = UIAlertController(title: "Error", message: alertDescription, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController .addAction(action)
    return alertController
}



//TODO: Firebase Storage Error Handling.
//TODO: Firebase Database Error Handling.




