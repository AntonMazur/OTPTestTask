//
//  OTPTestTaskTests.swift
//  OTPTestTaskTests
//
//  Created by Anton Mazur on 17.07.2024.
//

import XCTest
@testable import OTPTestTask

final class OTPTestTaskTests: XCTestCase {
    
    var sut: OTPUseCase!

    override func setUpWithError() throws {
        sut = OTPUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testResendCodeButtonEnabledAfterOneMinutePassed() {
        sut.startResendTimer()
        
        let expectation = expectation(description: "Test after 60 seconds")
        let result = XCTWaiter.wait(for: [expectation], timeout: 60)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(sut.isResendButtonEnabled, "Resend button should be enabled")
        }
    }
    
    func testResendCodeButtonDisabledUntilOneMinutePassed() {
        sut.startResendTimer()
        
        let exp = expectation(description: "Test after 50 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 50)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertFalse(sut.isResendButtonEnabled, "Resend button should be disabled")
        }
    }
    
    func testCodeValidation() {
        let validCode: String = Constants.validCode
        let invalidCode: String = "0000"
        
        let isValid = sut.validate(code: validCode)
        let isInvalid = sut.validate(code: invalidCode)
        
        XCTAssertTrue(isValid, "Validation should return true")
        XCTAssertFalse(isInvalid, "Validation should return false")
    }
    
    func testInvalidLengthCodeInput() {
        let shortCode: String = "123"
        sut.validateCodeLength(code: shortCode)
        XCTAssertFalse(sut.isContinueButtonEnabled, "Continue button should be disabled for incomplete code input")
    }
    
    func testValidLengthCodeInput() {
        let completedCode: String = "1111"
        sut.validateCodeLength(code: completedCode)
        XCTAssertTrue(sut.isContinueButtonEnabled, "Continue button should be enabled for completed code input")
    }
    
    // Here we test isCodeValid property as it's responsible for changing view presentation (turns Text Fields to red color) when invalid code is entered
    func testInvalidCodeStatus() {
        let invalidCode = "0000"
        _ = sut.validate(code: invalidCode)
        XCTAssertFalse(sut.isCodeValid, "Valid OTP should return false")
    }
    
    func testValidCodeStatus() {
        let validCode = Constants.validCode
        _ = sut.validate(code: validCode)
        XCTAssertTrue(sut.isCodeValid, "Valid OTP should return false")
    }
}
