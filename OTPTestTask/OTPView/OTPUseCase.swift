//
//  OTPUseCase.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 17.07.2024.
//

import Combine
import Foundation

final class OTPUseCase {
    @Published var isResendButtonEnabled: Bool = false
    @Published var isContinueButtonEnabled: Bool = false
    @Published var isCodeValid: Bool = true
    
    private var timer: AnyCancellable?
    
    func startResendTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.isResendButtonEnabled = true
        }
    }
    
    func validateCodeLength(code: String) {
        isContinueButtonEnabled = code.count == Constants.requiredCodeLength
    }
    
    func validate(code: String) -> Bool {
        isCodeValid = code == Constants.validCode
        return isCodeValid
    }
    
    func resendCode() {
        isResendButtonEnabled = false
        startResendTimer()
    }
}

