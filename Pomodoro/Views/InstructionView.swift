//
//  InstructionView.swift
//  Pomodoro
//
//  Created by Yohan Yoon on 2/3/25.
//

import SwiftUI

struct InstructionView: View {
    var body: some View {
        VStack {
            Text("About POMODORO")
                .font(.custom("DNFBitBitv2", size: 25))
            
            Text("Q. What is POMODORO?")
                .foregroundColor(.red)
                .font(.custom("DNFBitBitv2", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Text("It is a time management technique in which you focus on working for 25 or 50 minute intervals and take 5 or 10 minute break.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("DNFBitBitv2", size: 14))
                .padding()
            
            Text("Q. How to do it?")
                .foregroundColor(.red)
                .font(.custom("DNFBitBitv2", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Text("""
                1. Choose a task
                2. Set 25 or 50 minute timer
                3. Work on your task until timer is done
                4. Take a 5 or 10 minute break
                """)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom("DNFBitBitv2", size: 14))
            .padding()
            
            //it is a time management technique in which you focus on working for 25 or 50 minute intervals and take 5 or 10 minute break.
            Spacer()
            
            
        }
    }
}

#Preview {
    InstructionView()
}
