//
//  LockoutView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import SwiftUI

public struct LockoutView: View {
    private let until: Date
    private let onExpiry: () -> Void
    @State private var secondsLeft: Int = 0
    
    public init(until: Date, onExpiry: @escaping () -> Void) {
        self.until = until
        self.onExpiry = onExpiry
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 60))
            
            Text("Too many attempts")
                .font(.title)
            
            Text("Try again in")
            
            Text("\(secondsLeft)s")
                .font(.system(size: 52, weight: .bold, design: .monospaced))
        }
        .onAppear { tick() }
    }
    
    private func tick() {
        secondsLeft = max(0, Int(until.timeIntervalSinceNow))
        if secondsLeft <= 0 {
            onExpiry()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                tick()
            }
        }
    }
}
