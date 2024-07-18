//
//  OTPView.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 17.07.2024.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: OTPViewModel
    @FocusState private var fieldFocus: Int?
    
    var body: some View {
        VStack {
            otpFields
            buttonsView
        }
        .onAppear {
            viewModel.startResendTimer()
        }
    }
}

// MARK: - Views
private extension OTPView {
    private var otpFields: some View {
        HStack {
            ForEach(0..<Constants.requiredCodeLength, id: \.self) { index in
                ProtectedTextField(text: $viewModel.code[index])
                    .frame(width: 48, height: 48)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(viewModel.isCodeValid ? Color.clear : Color.red, lineWidth: 1)
                    )
                    .onChange(of: viewModel.code[index]) { _, newValue in
                        if newValue.count == 1 && index < Constants.requiredCodeLength - 1 {
                            fieldFocus = index + 1
                        } else if newValue.isEmpty && index > 0 {
                            fieldFocus = index - 1
                        }
                    }
            }
        }
    }
    
    private var buttonsView: some View {
        Group {
            Button {
                if viewModel.validateCodeAndContinue() {
                    coordinator.push(page: .success)
                }
            } label: {
                Text("Continue")
                    .padding()
                    .background(viewModel.isContinueButtonEnabled ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .font(.headline)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!viewModel.isContinueButtonEnabled)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            HStack(spacing: 10) {
                Text("Didn't receive the code?")
                
                Button("Resend") {
                    viewModel.resendCode()
                }
                .disabled(!viewModel.isResendButtonEnabled)
            }
            .padding(.top, 20)
        }
    }
}

// TextField with disabled Paste action
private struct ProtectedTextField: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var textField: UITextField?
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 1
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        
        @objc func doneButtonTapped() {
            textField?.resignFirstResponder()
        }
    }
    
    final private class ProtectedTextField: UITextField {
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(paste(_:)) {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = ProtectedTextField()
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        
        context.coordinator.textField = textField
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: context.coordinator, action: #selector(context.coordinator.doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
}
