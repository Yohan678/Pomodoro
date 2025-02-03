//
//  ContentView.swift
//  Pomodoro
//
//  Created by Yohan Yoon on 2/2/25.
//

import SwiftUI

struct ContentView: View {
    @State var countdownTimer: Int = 1500//total seconds
    @State var timerStringValue: String = "00:00" //value shows up on display
    @State var timerRunning = false
    
    @State var breakStart: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            //BackGround
            LinearGradient(colors: [Color("gradient1"), Color("gradient2")], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("POMODORO")
                    .font(.system(size: 30, weight: .light))
                
                Spacer ()
                
                Text(timerStringValue)
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning{
                            countdownTimer -= 1
                            updateTimerStringValue()
                        } else{
                            timerRunning = false
                        }
                    }
                    .font(.system(size: 55, weight: .bold))
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button { timerRunning = true } label: { Image(systemName: "play.fill")}
                        .padding()
                        .foregroundStyle(.white)
                        .font(.system(size: 50, weight: .bold))
                        .background(.blue, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                    Button { timerRunning = false } label: { Image(systemName: "pause.fill")}
                        .padding()
                        .foregroundStyle(.white)
                        .font(.system(size: 50, weight: .bold))
                        .background(.blue, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                } // play & pause buttons
                
                Spacer()
            }
            .onAppear { updateTimerStringValue() }
        }
    }
    
    func updateTimerStringValue() {
        let minutes = (countdownTimer % 3600) / 60
        let seconds = countdownTimer % 60
        
        timerStringValue = String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
