//
//  regexTests.swift
//  regexTests
//
//  Created by Can ATAC on 20/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import XCTest
@testable import regex

class regexTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhoneNumberIsValid() {
        XCTAssertTrue(
                {
                    do{
                        return try  RegexAPI().validate("Phone", value: "+33623243101")
                    }
                    catch{
                        print("PROBLEM")
                    }
                    return false
                    
        }(),"Phone Number is OK")

    }
    func testPhoneNumberIsInvalid(){
        XCTAssertFalse(
            {
                do{
                    return try  RegexAPI().validate("Phone", value: "+")
                }
                catch{
                    print("PROBLEM")
                }
                return false
                
                }(),"Phone Number is KO")
    }
    func testBadAPICall(){
        XCTAssertFalse(
            {
                do{
                    return try  RegexAPI().validate("PHONE", value: "+33623243101")
                }
                catch CARegexCallError.invalidType{
                    print("TYPE IS INVALID")
                }
                catch{
                    print("UNKNOWN ERROR")
                }
                return false
                
                }(),"CALL is KO")
    }
    
    func testValidationWithCompletionNominal(){
    
        let expectation = self.expectation(description: "testValidationWithCompletionNominal")
        
        let data = ["Phone":"+33623243101"]
        
        
        func delay(_ delay:Double, closure:@escaping ()->()){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        }
        
        RegexAPI().validateDataWithCompletion(data, completionHandler: { (result,error) -> Void in
            
            // When // data validation completes,control flow goes here.
            
            delay(3.0){        // SIMULATE LONG CALL AND COMPLETION HANDLER

                if result {
                    print("testValidationWithCompletionNominal : result of validation with completion : \(result)")
                } else {
                    print("testValidationWithCompletionNominal : result of validation with completion : \(result)")
                    
                }
                if (error != nil) {
                    print("testValidationWithCompletionNominal ERROR : \(error)")
                }
                expectation.fulfill()

            }
            
         })
        
        print("END OF TEST - Completion code is running")
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testValidationWithCompletionBadFormat(){
        
        let data = ["Phone":""]
        
        RegexAPI().validateDataWithCompletion(data, completionHandler: { (result,error) -> Void in
            
            // When // data validation completes,control flow goes here.
            
            if result {
                print("testValidationWithCompletionNominal : result of validation with completion : \(result)")
            } else {
                print("testValidationWithCompletionNominal : result of validation with completion : \(result)")
                
            }
            if (error != nil) {
                print("testValidationWithCompletionNominal ERROR : \(error)")
            }
        })
    }
    
    func testValidationWithCompletionBadType(){
        
        let data = ["PHone":"+33623243101"]
        
        RegexAPI().validateDataWithCompletion(data, completionHandler: { (result,error) -> Void in
                
                // When // data validation completes,control flow goes here.
                
                if result {
                    print("testValidationWithCompletionBadType : result of validation with completion : \(result)")
                } else {
                    print("testValidationWithCompletionBadType : result of validation with completion : \(result)")
                    
                }
                if (error != nil) {
                    print("testValidationWithCompletionBadType ERROR : \(error)")
                }
            })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAllDataValidationWithCompletionNominal(){
        
        let expectation = self.expectation(description: "testAllDataValidationWithCompletionNominal")
        
        let data = ["Phone":"+33623243101","Address":"121 Rue Henri Barbusse 92110 CLICHY","Name":"Can","Surname":"Atac","Email":"can.atac@gmail.com"]
        
        
        func delay(_ delay:Double, closure:@escaping ()->()){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        }
        
        RegexAPI().validateAllDataWithCompletion(data, completionHandler: { (result,error) -> Void in
            
            // When // data validation completes,control flow goes here.
            
            delay(3.0){        // SIMULATE LONG CALL AND COMPLETION HANDLER
                
                if result.0 {
                    print("testAllDataValidationWithCompletionNominal : result of validation with completion : \(result.0)")
                } else {
                    print("testAllDataValidationWithCompletionNominal : result of validation with completion : \(result.0)")
                    
                }
                if (error != nil) {
                    print("testAllDataValidationWithCompletionNominal ERROR : \(error)")
                }
                expectation.fulfill()
                
            }
            
        })
        
        print("END OF TEST - Completion code is running")
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testAllDataValidationWithCompletionEmptyPhone(){
        
        let expectation = self.expectation(description: "testAllDataValidationWithCompletionEmptyPhone")
        
        let data = ["Phone":"","Address":"121 Rue Henri Barbusse 92110 CLICHY","Name":"Can","Surname":"Atac","Email":"can.atac@gmail.com"]
        
        
        func delay(_ delay:Double, closure:@escaping ()->()){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        }
        
        RegexAPI().validateAllDataWithCompletion(data, completionHandler: { (result,error) -> Void in
            
            // When // data validation completes,control flow goes here.
            
            delay(3.0){        // SIMULATE LONG CALL AND COMPLETION HANDLER
                
                if result.0 {
                    print("testAllDataValidationWithCompletionEmptyPhone : result of validation with completion : \(result.0)")
                } else {
                    print("testAllDataValidationWithCompletionEmptyPhone : result of validation with completion : \(result.0)")
                    for key in result.1.keys {
                        print("Dic Results : \(key)-\(result.1[key]!)")
                    }
                    
                }
                if (error != nil) {
                    print("testAllDataValidationWithCompletionEmptyPhone ERROR : \(error)")
                }
                expectation.fulfill()
                
            }
            
        })
        
        print("END OF TEST - Completion code is running")
        waitForExpectations(timeout: 5, handler: nil)
    }

    
}
