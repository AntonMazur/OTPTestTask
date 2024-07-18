//
//  SuccessView.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 18.07.2024.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            Text("You are done!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    SuccessView()
}
