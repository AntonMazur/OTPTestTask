//
//  OTPViewModel.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 17.07.2024.
//

import Combine
import SwiftUI

final class OTPViewModel: ObservableObject {
    @Published var code: [String] = Array(repeating: "", count: Constants.requiredCodeLength) {
        didSet {
            let combinedCode = code.joined()
            useCase.validateCodeLength(code: combinedCode)
        }
    }
    
    @Published var isResendButtonEnabled: Bool = false
    @Published var isContinueButtonEnabled: Bool = false
    @Published var isCodeValid: Bool = true
    
    private var useCase: OTPUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: OTPUseCase) {
        self.useCase = useCase        
        setupBindings()
    }
    
    private func setupBindings() {
        useCase.$isResendButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.isResendButtonEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        useCase.$isContinueButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.isContinueButtonEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        useCase.$isCodeValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isInvalid in
                self?.isCodeValid = isInvalid
            }
            .store(in: &cancellables)
    }
    
    func startResendTimer() {
        guard !isResendButtonEnabled else { return }
        useCase.startResendTimer()
    }
    
    func resendCode() {
        useCase.resendCode()
    }
    
    func validateCodeAndContinue() -> Bool {
        let combinedCode = code.joined()
        let isValid = useCase.validate(code: combinedCode)
        return isValid
    }
}
