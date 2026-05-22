//
//  PINEntryView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import SwiftUI
import VigilCore

public struct PINEntryView: View {
    
    var viewModel: LockViewModel
    
    public init(viewModel: LockViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            
            VStack(spacing: 36) {
                
                Spacer()
                
                // Title
                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 36))
                    
                    Text(viewModel.confirmPIN.isEmpty
                         ? "Enter PIN"
                         : "Confrim PIN")
                    .font(.title)
                }
                
                // Dot indicators
                HStack(spacing: 20) {
                    ForEach(0..<PINValidator.pinLength, id: \.self) { index in
                        Circle()
                            .frame(width: 16, height: 16)
                            .scaleEffect(
                                index < viewModel.pinInput.count ? 1.1 : 1.0
                            )
                            .animation(
                                .spring(duration: 0.2),
                                value: viewModel.pinInput.count
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
                    viewModel.currentScreen = .biometric
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "faceid")
                        Text("Use Face ID")
                    }
                }
                
                Spacer().frame(height: 12)
                
            }
        }
    }
    
    private func handleKeyPress(_ key: String) {
        if key == "⌫" {
            viewModel.deleteLastDigit()
        } else {
            viewModel.appendDigit(key)
            
            // Auto-submit
            if viewModel.pinInput.count == PINValidator.pinLength {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    if viewModel.confirmPIN.isEmpty {
                        viewModel.submitPIN()
                    } else {
                        viewModel.confirmSetupPIN()
                    }
                }
            }
            
        }
    }
}
