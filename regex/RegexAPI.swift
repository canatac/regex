//
//  RegexAPI.swift
//  regex
//
//  Created by Can ATAC on 20/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import Foundation

enum CARegexCallError: ErrorType {
    case InvalidType
    case UnknownError
}
enum CARegexType: String {
    case Phone
    case Email
    case Address
    case Name
    case Surname
}

protocol CARegex{

    func validate(type:String, value:String) throws ->Bool
}

public class RegexAPI:CARegex {

    public var errors:[String:String]
    
    public init(){
        errors = [String:String]()
    }
    
    public func validate(type:String, value:String) throws ->Bool {
        switch type {
            
        case CARegexType.Phone.rawValue:
            return self.validatePhoneNumber(value)
        default:
            print("INTERNAL RegexAPI : INVALID TYPE - MUST BE Phone")
            throw CARegexCallError.InvalidType
            
        }

    }
    
    private func validate(data:[String:String]) throws ->Bool {
        var result = false
        for key in data.keys{
            switch key {
                case CARegexType.Phone.rawValue:
                    result  =   self.validatePhoneNumber(data[key]!)
                case CARegexType.Email.rawValue:
                    result  =   self.validateEmail(data[key]!)
                case CARegexType.Address.rawValue:
                    result  =   self.validateAddress(data[key]!)
                case CARegexType.Name.rawValue:
                    result  =   self.validateName(data[key]!)
                case CARegexType.Surname.rawValue:
                    result  =   self.validateSurname(data[key]!)
                default:
                    print("INTERNAL BAD INVALID TYPE - RTFM")
                    result = false
                    throw CARegexCallError.InvalidType                
            }
        }
        return result
    }

    private func validate(data:[String:String]) throws ->(Bool,[String:Bool]) {
        var globalResult    = true
        var result          = true

        var resultDic:[String:Bool] = [String:Bool]()
        
        for key in data.keys{
            switch key {
            case CARegexType.Phone.rawValue:
                result  =   self.validatePhoneNumber(data[key]!)
                resultDic[key]   =   result
                if !result {globalResult =   false}
                
            case CARegexType.Email.rawValue:
                result  =   self.validateEmail(data[key]!)
                resultDic[key]   =   result
                if !result {globalResult =   false}

            case CARegexType.Address.rawValue:
                result  =   self.validateAddress(data[key]!)
                resultDic[key]   =   result

                if !result {globalResult =   false}

            case CARegexType.Name.rawValue:
                result  =   self.validateName(data[key]!)
                resultDic[key]   =   result
                if !result {globalResult =   false}

            case CARegexType.Surname.rawValue:
                result  =   self.validateSurname(data[key]!)
                resultDic[key]   =   result
                if !result {globalResult =   false}

            default:
                print("INTERNAL BAD INVALID TYPE - RTFM")
                result = false
                resultDic[key]   =   result
                if !result {globalResult =   false}

                throw CARegexCallError.InvalidType
            }
        }
        return (globalResult,resultDic)
    }
    
    public func validateWithResponse(type:String, value:String) throws -> [String:String]{
        switch type {
            
        case CARegexType.Phone.rawValue:
            self.validatePhoneNumberWithResponse(value)
            return self.errors
        default:
            print("INTERNAL RegexAPI : INVALID TYPE - MUST BE Phone")
            throw CARegexCallError.InvalidType
        }

    }
    
    private func validatePhoneNumberWithResponse(phoneNumber:String){
        // ITU-T E.123
        let pattern = "^\\+(?:[0-9]\\x20?){6,14}[0-9]$"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !predicate.evaluateWithObject(phoneNumber){
            self.errors["Phone"] = "Phone format error"
        }
    }
    
    
    
    private func validatePhoneNumber(phoneNumber:String)->Bool{
        
        // ITU-T E.123
        
        let pattern = "^\\+(?:[0-9]\\x20?){6,14}[0-9]$"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(phoneNumber)
        
        // Extensible Provisioning Protocol (EPP)
        /*
        EPP-style phone numbers use the format +CCC.NNNNNNNNNNxEEEE, where C is the 1–3 digit country code, N is up to 14 digits, and E is the (optional) extension. The leading plus sign and the dot following the country code are required. The literal “x” character is required only if an extension is provided.
        */
        /*
        let phone2:String = "+33.623243101xBUSINESS"
        let pattern3 = "^\\+[0-9]{1,3}\\.[0-9]{4,14}(?:x.+)?$"
        let predicate3:NSPredicate = NSPredicate(format: "SELF MATCHES %@", pattern3)
        predicate3.evaluateWithObject(phone2)
        return true
*/
    }
    
    private func validateEmail(email:String?)->Bool{
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(email)
        
    }
    
    private func validateAddress(address:String?)->Bool{
        return address!.isEmpty ? false:true
    }
    
    private func validateName(name:String?)->Bool{
        return name!.isEmpty ? false:true
    }
    
    private func validateSurname(surname:String?)->Bool{
        return surname!.isEmpty ? false:true
    }
    
    typealias CompletionHandler = (result:Bool, error:ErrorType?) throws -> Void

    func validateDataWithCompletion(data:[String:String],completionHandler: CompletionHandler) {
        
            do{
                try completionHandler(result:self.validate(data),error: nil)
            }catch CARegexCallError.InvalidType{
                print("completionHandler : TYPE IS INVALID")
                try! completionHandler(result: false,error: CARegexCallError.InvalidType)
            }catch{
                print("completionHandler : OTHER ERROR")
                try! completionHandler(result: false,error: CARegexCallError.UnknownError)
                //error = CARegexCallError.UnknownError
            }
    
    }
    
    public typealias CompletionHandlerForAllData = (result:(Bool,[String:Bool]), error:ErrorType?) throws -> Void

    public func validateAllDataWithCompletion(data:[String:String],completionHandler: CompletionHandlerForAllData) {
        
        do{
            try completionHandler(result:self.validate(data),error: nil)
        }catch CARegexCallError.InvalidType{
            print("completionHandler : TYPE IS INVALID")
            try! completionHandler(result: (false,[:]),error: CARegexCallError.InvalidType)
        }catch{
            print("completionHandler : OTHER ERROR")
            try! completionHandler(result: (false,[:]),error: CARegexCallError.UnknownError)
            //error = CARegexCallError.UnknownError
        }
        
    }

    
}