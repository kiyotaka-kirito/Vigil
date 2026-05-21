//
//  PINSetupView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import SwiftUI
import VigilCore

struct PINSetupView: View {
    
    var viewModel: LockViewModel
    
    public init(viewModel: LockViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 36) {
            
            Spacer()
            
            // Title
            VStack(spacing: 12) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 52))
                
                Text("Create a PIN")
                    .font(.title)
                
                Text("You'll use this to unlock\n Vigil")
                    .multilineTextAlignment(.center)
            }
            
            // Dot indicators
            HStack(spacing: 20) {
                ForEach(0..<PINValidator.pinLength, id: \.self) { index in
                    Circle()
                        .frame(width: 16, height: 16)
                        .scaleEffect(
                            index < viewModel.setupPIN.count ? 1.1 : 1.0
                        )
                        .animation(
                            .spring(duration: 0.2),
                            value: viewModel.setupPIN.count
                        )
                }
            }
            
            // Error
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .transition(.opacity)
            }
            
            // Number pad
            NumberPad(viewModel: viewModel, handle: handleKeyPress(_:))
            
            // Face ID fallback
            Button {
                
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "faceid")
                    Text("Use Face ID")
                }
            }
            
            Spacer().frame(height: 12)
            
        }
    }
    
    
    private func handleKeyPress(_ key: String) {
        if key == "⌫" {
            if !viewModel.setupPIN.isEmpty {
                viewModel.setupPIN.removeLast()
            }
        } else if viewModel.setupPIN.count < PINValidator.pinLength {
            viewModel.setupPIN += key
            
            // Auto-submit
            if viewModel.pinInput.count == PINValidator.pinLength {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    viewModel.submitSetupPIN()
                }
            }
            
        }
    }
    
}

