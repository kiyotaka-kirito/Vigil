//
//  LockView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import SwiftUI

public struct LockView: View {
    
    var viewModel: LockViewModel
    
    public init(viewModel: LockViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
            
            // App icon and Title
            VStack(spacing: 12) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 64))
                
                Text("Vigil")
                    .font(.title)
                
                Text("Tap to unlock with Face ID")
            }
            
            Spacer()
            
            // Face ID button
            Button {
                viewModel.authenticateWithBiometrics()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "faceid")
                        .font(.system(size: 20))
                    Text("Unlock with Face ID")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 32)
            }
            
            // Use PIN instead
            Button {
                viewModel.currentScreen = .pin
            } label: {
                Text("Use PIN instead")
            }
            
            Spacer().frame(height: 20)
            
        }
        .onAppear { viewModel.authenticateWithBiometrics() }
    }
}

