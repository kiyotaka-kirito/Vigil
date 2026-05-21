//
//  NumberPad.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import SwiftUI
import VigilCore

public struct NumberPad: View {
    
    var viewModel: LockViewModel
    let handle: (String) -> Void
    
    let digits = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"],
    ]
    
    public var body: some View {
        VStack(spacing: 14) {
            ForEach(digits, id: \.self) { row in
                HStack(spacing: 24) {
                    ForEach(row, id: \.self) { key in
                        if key.isEmpty {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 72, height: 72)
                        } else {
                            PINKey(label: key) { handle(key) }
                        }
                    }
                }
            }
        }
    }
}

struct PINKey: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background(.white.opacity(0.12))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
    }
}
