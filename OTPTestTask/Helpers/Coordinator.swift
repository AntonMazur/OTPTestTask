//
//  Coordinator.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 17.07.2024.
//

import SwiftUI

enum Pages: String, Identifiable {
    case otp, success
    var id: String { self.rawValue }
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentPage: Pages = .otp
    
    func push(page: Pages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func getPage(_ page: Pages) -> some View {
        switch page {
        case .otp:
            let useCase = OTPUseCase()
            let viewModel = OTPViewModel(useCase: useCase)
            OTPView(viewModel: viewModel)
        case .success:
            SuccessView()
        }
    }
}
